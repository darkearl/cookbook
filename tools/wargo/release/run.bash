#!/bin/bash -e

# ------------------------------------------------------------------------------
# STEPS TO RELEASE
#   1. List all of files from svn logs
#   2. Download source from Product Sys to Release Dir BY FTP
#   3. Compare source bettwen Dev Dir with Release Dir
#   4. Minify js/css fiels from Release Dir
#   5. Upload source from Release Dir to Product Sys
# ------------------------------------------------------------------------------
function listFiles()
{
    echo
}

function downloadSource()
{
    local -r tempFolder="$(getTemporaryFolder)"

    header 'Download source from Product Sys to Release Dir BY FTP'

    info '1. List all of files from svn logs'
    info '2. Enter path of file input.txt'

    prompt_user step "Please choice:" '1'
    case $step in
        1 ) getSvnLogs "${tempFolder}";;
        2 ) copyFileDownloadInput "${tempFolder}" ;;
        *) fatal 'Invalid response -- please reenter:';
           downloadSource;;
    esac

    info "See folder "${tempFolder}" for more infomation..."
    read -n 1 -s -r -p "Press any key to continue download file"
    main
}
function showDescription()
{
    header 'STEPS TO RELEASE WARGO.JP'

    info '1. Download source from Product Sys to Release Dir BY FTP'
    info '2. Compare source bettwen Dev Dir with Release Dir'
    info '3. Minify js/css fiels from Release Dir'
    info '4. Upload source from Release Dir to Product Sys'
}

function main()
{
    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${appFolderPath}/../../../libraries/Utils.bash"
    source "${appFolderPath}/config.bash"
    source "${appFolderPath}/downloadSource.bash"


    showDescription
    prompt_user step "Enter steps:" '1'
    case $step in
        1 ) downloadSource;;
        2 ) answer="n";;
        *) finish="-1";
           echo -n 'Invalid response -- please reenter:';;
    esac
}

main "${@}"