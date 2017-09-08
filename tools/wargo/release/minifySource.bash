#!/bin/bash -e

function wargoMinify(){
    local -r sourceCodeDir="${BACKUP_FOLDER[1]}"
    # setting auto
    mapJsCssPathTemp="$TMP_FOLDER/mapreltemp.txt"
    inputFile="${MINIFY_INPUT_PATH}"
    mapJsCssPath="${sourceCodeDir}/${WARGO_MAP_MINIFY_PATH}"
    # others
    minifyFile=0

    debug "Create back up file map from $mapJsCssPath"
    if [ -f "$mapJsCssPath" ]; then
        cp "$mapJsCssPath" "$mapJsCssPathTemp"
    else
        echo "" > ${mapJsCssPathTemp}
    fi

    debug "Check contents of $inputFile"
    if [ -f "$inputFile" ]; then
        while read line ; do
            sourceCodeFile="${sourceCodeDir}/${line}"
            fullName=$(basename "$sourceCodeFile")
            if [ -f "$sourceCodeFile" ]; then
                minifyFile=1
                # coppy minified file
                fileName="$(getFileName $sourceCodeFile)"
                fileExt="$(getFileExtension $sourceCodeFile)"
                # minify file
                minify -c --template "$fileName-{{md5}}.min.$fileExt" "$sourceCodeFile" >/dev/null 
                
                minifyFileOutTpl=$(dirname "$sourceCodeFile")"/$fileName-*.min.$fileExt"
                minifyFileOut=`ls $minifyFileOutTpl | head -n 1`
                if [ -f "$minifyFileOut" ]; then
                    echo "${fullName} >> $(basename "$minifyFileOut")"
                    local -r partentToSearch="$line:"
                    local -r stringToReplace="$line:`dirname $line`/`basename $minifyFileOut`"
                    replaceOrAppendToFile "${mapJsCssPathTemp}" "${partentToSearch}" "${stringToReplace}"
                fi
            else
                warn "File ${fullName} does not exist"
            fi
        done < $inputFile
    else
        echo "$inputFile does not exist"
    fi

    if [ $minifyFile -eq 0 ]; then
        warn "There is no file to minify"
    else
        debug "Create new file map to $mapJsCssPath"
        grep -o -E ".*\.min\.css$" $mapJsCssPathTemp | sort | uniq > $mapJsCssPath
        grep -o -E ".*\.min\.js$" $mapJsCssPathTemp | sort | uniq >> $mapJsCssPath
    fi
    rm $mapJsCssPathTemp

}