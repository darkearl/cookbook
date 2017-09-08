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

function getFullFileName()
{
    local -r string="${1}"
    
    echo "$(basename "${string}")"
}

function getFileExtension()
{
    local -r string="${1}"

    local -r fullFileName="$(basename "${string}")"

    echo "${fullFileName##*.}"
}

function getFileName()
{
    local -r string="${1}"

    local -r fullFileName="$(basename "${string}")"

    echo "${fullFileName%.*}"
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

function appendToFileIfNotFound()
{
    local -r file="${1}"
    local -r pattern="${2}"
    local -r string="${3}"
    local -r patternAsRegex="${4}"
    local -r stringAsRegex="${5}"
    local -r addNewLine="${6}"

    # Validate Inputs

    checkExistFile "${file}"
    checkNonEmptyString "${pattern}" 'undefined pattern'
    checkNonEmptyString "${string}" 'undefined string'
    checkTrueFalseString "${patternAsRegex}"
    checkTrueFalseString "${stringAsRegex}"

    if [[ "${stringAsRegex}" = 'false' ]]
    then
        checkTrueFalseString "${addNewLine}"
    fi

    # Append String

    local grepOptions=('-F' '-o')

    if [[ "${patternAsRegex}" = 'true' ]]
    then
        grepOptions=('-E' '-o')
    fi

    local -r found="$(grep "${grepOptions[@]}" "${pattern}" "${file}")"

    if [[ "$(isEmptyString "${found}")" = 'true' ]]
    then
        if [[ "${stringAsRegex}" = 'true' ]]
        then
            echo -e "${string}" >> "${file}"
        else
            if [[ "${addNewLine}" = 'true' ]]
            then
                echo >> "${file}"
            fi

            echo "${string}" >> "${file}"
        fi
    fi
}

function replaceOrAppendToFile()
{
    local -r file="${1}"
    local -r pattern="${2}"
    local -r string="${3}"


    # Validate Inputs

    checkExistFile "${file}"
    checkNonEmptyString "${pattern}" 'undefined pattern'
    checkNonEmptyString "${string}" 'undefined string'

    local grepOptions=('-r' '-n')

    local -r found="$(grep "${grepOptions[@]}" "${pattern}" "${file}" | cut -d : -f 1)"

    if [[ "$(isEmptyString "${found}")" = 'false' ]]
    then
        sed -i "${found} c ${string}" ${file}
    else
        echo "${string}" >> "${file}"
    fi
}