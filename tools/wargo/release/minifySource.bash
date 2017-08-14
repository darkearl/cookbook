#!/bin/bash -e

function wargoMinify(){
    local -r sourceCodeDir="${BACKUP_FOLDER[1]}"
    # setting auto
    mapJsCssPathTemp="$TMP_FOLDER/mapreltemp.txt"
    inputFile="${MINIFY_INPUT_PATH}"
    mapJsCssPath="${sourceCodeDir}/${WARGO_MAP_MINIFY_PATH}"
    # others
    minifyFile=0

    echo "-------------------------------------------------------------------------------------------------------------------"

    echo "-------- Create back up file map from $mapJsCssPath"
    if [ -f "$mapJsCssPath" ]; then
        cp "$mapJsCssPath" "$mapJsCssPathTemp"
    else
        echo "" > ${mapJsCssPathTemp}
    fi

    if [ -f "$inputFile" ]; then
        echo "-------- Check contents of $inputFile"
        while read line ; do
            sourceCodeFile="${sourceCodeDir}/${line}"
            echo ${sourceCodeFile}
            if [ -f "$sourceCodeFile" ]; then
                minifyFile=1
                # coppy minified file
                fullName=$(basename "$sourceCodeFile")
                fileName="${fullName%.*}"
                fileExt="${fullName##*.}"

                # minify file
                echo "---------------- $sourceCodeFile `minify -c --template $fileName-{{md5}}.min.$fileExt $sourceCodeFile`"

                minifyFileOutTpl=$(dirname "$sourceCodeFile")"/$fileName-*.min.$fileExt"
                minifyFileOut=`ls $minifyFileOutTpl | head -n 1`
                if [ -f "$minifyFileOut" ]; then
                    echo "---------------- $minifyFileOut (Minified)"
                    # edit file map
                    mapNumlimes=`grep -r -n "$line:" $mapJsCssPathTemp | cut -d : -f 1`
                    firstLine=1
                    nomap=0
                    newtextline="$line:`dirname $line`/`basename $minifyFileOut`"
                    for mapNumlime in $mapNumlimes; do
                        if [ $firstLine -eq 1 ]; then
                            sed -i "$mapNumlime c $newtextline" $mapJsCssPathTemp
                        else
                            sed -i "$mapNumlime d" $mapJsCssPathTemp
                        fi
                        firstLine=0
                        nomap=1
                    done
                    firstLine=0

                    if [ $nomap -eq 0 ]; then
                        sed -i "$ i $newtextline" $mapJsCssPathTemp
                    fi
                fi
            else
                echo "---------------- $sourceCodeFile does not exist"
            fi
        done < $inputFile
    else
        echo "-------- $inputFile does not exist"
    fi

    if [ $minifyFile -eq 0 ]; then
        echo "-------- There is no file to minify"
    else
        echo "-------- Create new file map to $mapJsCssPath"
        grep -o -E ".*\.min\.css$" $mapJsCssPathTemp | sort | uniq > $mapJsCssPath
        grep -o -E ".*\.min\.js$" $mapJsCssPathTemp | sort | uniq >> $mapJsCssPath
    fi
    rm $mapJsCssPathTemp
    echo "-------------------------------------------------------------------------------------------------------------------"

}