#!/bin/bash -e

#########################
# File Local Utils      #
#########################

function getFileExtension()
{
    local -r string="${1}"

    local -r fullFileName="$(basename "${string}")"

    echo "${fullFileName##*.}"
}

function checkExistFile()
{
    local -r file="${1}"
    local -r errorMessage="${2}"

    if [[ "${file}" = '' || ! -f "${file}" ]]
    then
        if [[ "$(isEmptyString "${errorMessage}")" = 'true' ]]
        then
            fatal "file '${file}' not found"
        fi

        fatal "${errorMessage}"
    fi
}

function checkExistFolder()
{
    local -r folder="${1}"
    local -r errorMessage="${2}"

    if [[ "${folder}" = '' || ! -d "${folder}" ]]
    then
        if [[ "$(isEmptyString "${errorMessage}")" = 'true' ]]
        then
            fatal "folder '${folder}' not found"
        fi

        fatal "${errorMessage}"
    fi
}

function copyFolderContent()
{
    local -r sourceFolder="${1}"
    local -r destinationFolder="${2}"

    checkExistFolder "${sourceFolder}"
    checkExistFolder "${destinationFolder}"

    local -r currentPath="$(pwd)"

    cd "${sourceFolder}"
    find '.' -maxdepth 1 -not -name '.' -exec cp -p -r '{}' "${destinationFolder}" \;
    cd "${currentPath}"
}

function printFolder()
{
    local -r sourceFolder="${1}"
    checkExistFolder "${sourceFolder}"

    if [[ "$(existCommand 'tree')" = 'false' ]]
    then
        error 'The program tree is currently not installed. You can install it by typing:\nsudo apt-get install tree'
    else
        tree "${sourceFolder}"
    fi
}