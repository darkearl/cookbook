#!/bin/bash -e

# ------------------------------------------------------------------------------
# STEPS TO RELEASE
#   1. List all of files from svn logs
#   2. Download source from Product Sys to Release Dir BY FTP
#   3. Compare source bettwen Dev Dir with Release Dir
#   4. Minify js/css fiels from Release Dir
#   5. Upload source from Release Dir to Product Sys
# ------------------------------------------------------------------------------
function init()
{
    TMP_FOLDER="$(getTemporaryFolder)"
    GROUP_LOG_PATH="${TMP_FOLDER}/${FILE_SVN_GROUP_LOGS}"
    DOWNLOAD_INPUT_PATH="${TMP_FOLDER}/${FILE_DOWNLOAD_INPUT}"
    MINIFY_INPUT_PATH="${TMP_FOLDER}/${FILE_MINIFY_INPUT}"
}

function downloadSource()
{
    # Need before start
    init

    header 'Download source from Product Sys to Release Dir BY FTP'

    info '1. List all of files from svn logs'
    info '2. Enter path of file input.txt'

    prompt_user step "Please choice:" '1'
    case $step in
        1 ) getSvnLogs;;
        2 ) copyFileDownloadInput;;
        *) fatal 'Invalid response -- please reenter:';
           downloadSource;;
    esac


    # download
    read -n 1 -s -r -p "Press any key to continue download file"
    echo
    downloadFile
    # backup
    prompt_user backupName "Enter name of backup folder:"
    read -a BACKUP_FOLDER <<< $(backupFile ${backupName})
    
    info "See folder "${TMP_FOLDER}" for more infomation..."
    # return main menu
    goToMain
}

function uploadSource(){
    if [[ "$(existCommand 'filezilla')" = 'false' ]]
    then
        error 'filezilla not install!'
    fi

    if [[ "$(isEmptyString "${BACKUP_FOLDER[1]}")" = 'true' ]]
    then
        warn 'Download source before upload!'
    else
        filezilla -c "0/wargo" -a "${BACKUP_FOLDER[1]}"
    fi

    goToMain
}

function compareSource(){
    if [[ "$(existCommand 'bcompare')" = 'false' ]]
    then
        error 'bcompare not install!'
    fi

    if [[ "$(isEmptyString "${BACKUP_FOLDER[1]}")" = 'true' ]]
    then
        warn 'Download source before compare!'
    else
        bcompare "${SOURCE_DEV_WARGO}" ${BACKUP_FOLDER[1]}
    fi
    goToMain
}

function minifySource(){
    if [[ "$(existCommand 'minify')" = 'false' ]]
    then
        error 'minify not install!'
    fi

    if [[ "$(isEmptyString "${BACKUP_FOLDER[1]}")" = 'true' ]]
    then
        warn 'Download source before minify!'
    else
        wargoMinify
    fi
    goToMain
}


function goToMain(){
    echo
    read -n 1 -s -r -p "Press any key to go to main menu"
    echo
    main
}
function showDescription()
{
    header 'STEPS TO RELEASE WARGO.JP'

    info '1. Download source from Product Sys to Release Dir BY FTP'
    info '2. Compare source bettwen Dev Dir with Release Dir'
    info '3. Minify js/css fiels from Release Dir'
    info '4. Upload source from Release Dir to Product Sys'
    info "5. View upload folder ${BACKUP_FOLDER[1]}" 
}

function main()
{
    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${appFolderPath}/../../../libraries/Utils.bash"
    source "${appFolderPath}/default.cfg"
    source "${appFolderPath}/downloadSource.bash"
    source "${appFolderPath}/minifySource.bash"

    showDescription
    prompt_user step "Enter steps:" '1'
    case $step in
        1 ) downloadSource;;
        2 ) compareSource;;
        3 ) minifySource;;
        4 ) uploadSource;;
        5 ) printFolder ${BACKUP_FOLDER[1]};
            goToMain;;
        *)  echo -n 'Invalid response -- exit;';
            exit;;
    esac
}

main "${@}"