#!/bin/bash -e

function getSvnLogs()
{
    local -r tmpFolder="${1}"
    local -r groupLogsPath="${tmpFolder}/${FILE_SVN_GROUP_LOGS}"
    local -r downloadInputPath="$tmpFolder/${FILE_DOWNLOAD_INPUT}"
    local -r minifyInputPath="$tmpFolder/${FILE_MINIFY_INPUT}"

    local result=''
    prompt_user taskIds "Please input task ids(ex: 123 456):" '20511'

    for taskId in "${taskIds[@]}"
    do
        debug "Searching for task #${taskId}:"
        result+="$(searchSvn "#${taskId}")"
    done

    local allLinks=$(sortUniqArray "${result[@]}")
    local groupA=$(echo "${allLinks}" | grep -o -E "^   A /Projects/Wargo/04_Source/wargo\.jp/.*\.[[:alpha:]]{2,6}(\s|$)")
    local groupM=$(echo "${allLinks}" | grep "^   M /Projects/Wargo/04_Source/wargo\.jp/.*\.")
    local jsCssFile=$(getJsCssFile "${allLinks[@]}")
    
    local groupD=$(echo "${allLinks}" | grep "^   D /Projects/Wargo/04_Source/wargo\.jp/.*\.")
    
    local contentLog=(
        "--------------------------------------------A (added files)--------------------------------------------"
        "${groupA[@]}"
        "--------------------------------------------M (updated files)------------------------------------------"
        "${groupM[@]}"
        "--------------------------------------------D (deleted files)------------------------------------------"
        "${groupD[@]}"
    )

    debug "Group list:"
    arrayToString "${contentLog[@]}"

    debug "Saving group list into ${groupLogsPath}"
    arrayToString "${contentLog[@]}" > "${groupLogsPath}"

    debug "Saving list to minify ${minifyInputPath}"    
    arrayToString "${jsCssFile[@]}" > "${minifyInputPath}"

    debug "Saving list to download ${downloadInputPath}"    
    arrayToString "${groupM[@]}" > "${downloadInputPath}"

    fixPath "${minifyInputPath}"    
    fixPath "${downloadInputPath}"
}

function searchSvn()
{
    local -r taskId="${1}"
    svn log ${WARGO_SVN} -v --search ${taskId}
}

function copyFileDownloadInput(){
    local -r tmpFolder="${1}"
    local -r downloadInputPath="${tmpFolder}/${FILE_DOWNLOAD_INPUT}"
    local -r minifyInputPath="$tmpFolder/${FILE_MINIFY_INPUT}"

    prompt_user inputFilePath "Input path:"

    checkExistFile "${inputFilePath}"

    debug "Saving list to download ${downloadInputPath}"    
    cp -p ${inputFilePath} ${downloadInputPath}

    debug "Saving list to minify ${minifyInputPath}"    
    local jsCssFile = $(grep -E "\.(css|js)$" "${downloadInputPath}")

    fixPath "${downloadInputPath}"
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