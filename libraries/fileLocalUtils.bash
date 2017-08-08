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