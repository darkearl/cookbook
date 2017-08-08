#!/bin/bash -e

#########################
# FILE REMOTE UTILITIES #
#########################

function checkExistURL()
{
    local -r url="${1}"

    if [[ "$(existURL "${url}")" = 'false' ]]
    then
        fatal "url '${url}' not found"
    else
        debug "url '${url}' is working"
    fi
}

function existURL()
{
    local -r url="${1}"

    # Install Curl

    installCURLCommand > '/dev/null'

    # Check URL

    if ( curl -f --head -L "${url}" -o '/dev/null' -s --retry 12 --retry-delay 5 ||
         curl -f -L "${url}" -o '/dev/null' -r 0-0 -s --retry 12 --retry-delay 5 )
    then
        echo 'true'
    else
        echo 'false'
    fi
}

function downloadFile()
{
    local -r url="${1}"
    local -r destinationFile="${2}"
    local overwrite="${3}"

    checkExistURL "${url}"

    # Check Overwrite

    if [[ "$(isEmptyString "${overwrite}")" = 'true' ]]
    then
        overwrite='false'
    fi

    checkTrueFalseString "${overwrite}"

    # Validate

    if [[ -f "${destinationFile}" ]]
    then
        if [[ "${overwrite}" = 'false' ]]
        then
            fatal "file '${destinationFile}' found"
        fi

        rm -f "${destinationFile}"
    elif [[ -e "${destinationFile}" ]]
    then
        fatal "file '${destinationFile}' already exists"
    fi

    # Download

    debug "Downloading '${url}' to '${destinationFile}'\n"
    curl -L "${url}" -o "${destinationFile}" --retry 12 --retry-delay 5
}

function unzipRemoteFile()
{
    local -r downloadURL="${1}"
    local -r installFolder="${2}"
    local extension="${3}"

    # Install wget
    installWgetCommand

    # Validate URL

    checkExistURL "${downloadURL}"

    # Find Extension

    local exExtension=''

    if [[ "$(isEmptyString "${extension}")" = 'true' ]]
    then
        extension="$(getFileExtension "${downloadURL}")"
        exExtension="$(rev <<< "${downloadURL}" | cut -d '.' -f 1-2 | rev)"
    fi

    # Unzip

    if [[ "$(grep -i '^tgz$' <<< "${extension}")" != '' || "$(grep -i '^tar\.gz$' <<< "${extension}")" != '' || "$(grep -i '^tar\.gz$' <<< "${exExtension}")" != '' ]]
    then
        debug "Downloading '${downloadURL}'\n"
        curl -L "${downloadURL}" --retry 12 --retry-delay 5 | tar -C "${installFolder}" -x -z --strip 1
        echo
    elif [[ "$(grep -i '^tar\.bz2$' <<< "${exExtension}")" != '' ]]
    then
        # Install BZip2

        installBZip2Command

        # Unzip

        debug "Downloading '${downloadURL}'\n"
        curl -L "${downloadURL}" --retry 12 --retry-delay 5 | tar -C "${installFolder}" -j -x --strip 1   
        echo
    elif [[ "$(grep -i '^zip$' <<< "${extension}")" != '' ]]
    then
        # Install Unzip

        installUnzipCommand

        # Unzip

        if [[ "$(existCommand 'unzip')" = 'false' ]]
        then
            fatal 'command unzip not found'
        fi

        local -r zipFile="${installFolder}/$(basename "${downloadURL}")"

        downloadFile "${downloadURL}" "${zipFile}" 'true'
        unzip -q "${zipFile}" -d "${installFolder}"
        rm -f "${zipFile}"
        echo
    else
        fatal "file extension '${extension}' not supported"
    fi
}