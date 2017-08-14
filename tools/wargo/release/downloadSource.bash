#!/bin/bash -e

function getSvnLogs()
{
    local result=''
    prompt_user taskIds "Please input task ids(ex: 123 456):" '20511'
    local array=(${taskIds[@]})
    for taskId in "${array[@]}"
    do
        if [[ "$(isRevision "${taskId}")" = 'true' ]]
        then
           debug "Searching for revision ${taskId}:"
        else
           debug "Searching for task #${taskId}:"
        fi
        
        result+="$(searchSvn "${taskId}" "${taskId:0:1}")"
    done

    local allLinks=$(sortUniqArray "${result[@]}")
    local groupA=$(echo "${allLinks}" | grep -o -E "^   A /Projects/Wargo/04_Source/wargo\.jp/.*\.[[:alpha:]]{2,6}(\s|$)")
    local groupM=$(echo "${allLinks}" | grep "^   M /Projects/Wargo/04_Source/wargo\.jp/.*\.")
    local jsCssFile=$(getJsCssFile "${allLinks[@]}")

    if [[ "$(isEmptyString "${jsCssFile}")" = 'false' ]]
    then
        groupM+=("   M /Projects/Wargo/04_Source/wargo.jp/${WARGO_MAP_MINIFY_PATH}")
    fi

    local groupD=$(echo "${allLinks}" | grep "^   D /Projects/Wargo/04_Source/wargo\.jp/.*\.")
    
    local contentLog=(
        "--------------------------------------------A (added files)--------------------------------------------"
        "${groupA[@]}"
        "--------------------------------------------M (updated files)------------------------------------------"
        "${groupM[@]}"
        "--------------------------------------------D (deleted files)------------------------------------------"
        "${groupD[@]}"
    )

    debug 'Info:'
    arrayToString "${contentLog[@]}"

    debug "Saving group list into ${GROUP_LOG_PATH}"
    arrayToString "${contentLog[@]}" > "${GROUP_LOG_PATH}"
    

    debug "Saving list to minify ${MINIFY_INPUT_PATH}"    
    arrayToString "${jsCssFile[@]}" > "${MINIFY_INPUT_PATH}"

    debug "Saving list to download ${DOWNLOAD_INPUT_PATH}" 
    arrayToString "${groupM[@]}" > "${DOWNLOAD_INPUT_PATH}"

    fixPath "${MINIFY_INPUT_PATH}"    
    fixPath "${DOWNLOAD_INPUT_PATH}"
}

function searchSvn()
{
    local -r taskId="${1}"
    local -r firstLetter="${2}"
    if [[ ${firstLetter} == "r" ]]
    then
       svn log ${WARGO_SVN} -v -r ${taskId}
    else
       svn log ${WARGO_SVN} -v --search "#${taskId}"
    fi
    
}

function copyFileDownloadInput(){
    prompt_user inputFilePath "Input path:" '/media/projects/wargo_site/tools/wargo_new_download/shell_script/download/input.txt'

    checkExistFile "${inputFilePath}"

    debug "Saving list to download ${DOWNLOAD_INPUT_PATH}"    
    cp -p ${inputFilePath} ${DOWNLOAD_INPUT_PATH}

    local allLinks=$(cat "${DOWNLOAD_INPUT_PATH}")

    local jsCssFile=$(echo "${allLinks}"| grep -E "\.(css|js)$")

    if [[ "$(isEmptyString "${jsCssFile}")" = 'false' ]]
    then
        echo -e "\n${WARGO_MAP_MINIFY_PATH}" >> ${DOWNLOAD_INPUT_PATH}
        debug "Saving list to minify ${MINIFY_INPUT_PATH}"    
        arrayToString "${jsCssFile[@]}" > "${MINIFY_INPUT_PATH}"
        fixPath "${MINIFY_INPUT_PATH}"
    fi

    fixPath "${DOWNLOAD_INPUT_PATH}"
}

function fixPath()
{
    local -r filePath="${1}"

    checkExistFile "${filePath}"
    
    sed -i "s/^[[:space:]][[:space:]][[:space:]][AMD][[:space:]]\/Projects\/Wargo\/04_Source\/wargo\.jp\///g;" ${filePath}
    sed -i 's/[[:blank:]]//g' ${filePath}
}

function getJsCssFile()
{
    local -r data=("${@}")
    
    echo "${data}" | grep -o -E "^   [AM] /Projects/Wargo/04_Source/wargo\.jp/.*\.css(\s|$)"
    echo "${data}" | grep -o -E "^   [AM] /Projects/Wargo/04_Source/wargo\.jp/.*\.js(\s|$)"
}

function isRevision()
{
    local -r str="${1}"
    if [[ ${str:0:1} == "r" ]]
    then
        echo 'true'
    else
        echo 'false'
    fi
}

function download()
{
    local -r uri="${1}"
    local -r downloadDir="${2}"
    echo "Downloading ${uri}   " 
    wget "${WARGO_OPTION_DOWNLOAD[@]}" "${uri}" --directory-prefix=${downloadDir} -q
    if [ ${PIPESTATUS[0]} -ne 0 -o $? -ne 0 ]; then
        echo 'False'
    else
        echo 'OK'
    fi
}

function downloadFile(){
    local -r downloadDir="${TMP_FOLDER}/download/"
    debug "Prepare folder for download: ${downloadDir}"
    mkdir ${downloadDir}

    # start
    read -a allLinks <<< $(cat "${DOWNLOAD_INPUT_PATH}")
    for link in "${allLinks[@]}"
    do
        local uri="${WARGO_FTP_HOST}/${link}"
        local ret=$(download ${uri} ${downloadDir})
        echo ${ret}
    done
}

function backupFile(){
    local -r nameBackupFolder="${1}"
    local -r downloadDir="${TMP_FOLDER}/download/"
    local -r targetDir="${WARGO_BACKUP_FOLDER}/${nameBackupFolder}"
    local -r originDir="${targetDir}/origin"
    local -r uploadDir="${targetDir}/upload"

    [ ! -d $originDir ] && mkdir -p $originDir
    [ ! -d $uploadDir ] && mkdir -p $uploadDir

    copyFolderContent "${downloadDir}" "${originDir}"
    copyFolderContent "${downloadDir}" "${uploadDir}"
    echo "${originDir} ${uploadDir}"
}