#!/bin/bash -e

###################
# ARRAY UTILITIES #
###################



function arrayToString()
{
    local -r array=("${@}")

    arrayToStringWithDelimiter '\n' "${array[@]}"
}

function arrayToStringWithDelimiter()
{
    local -r delimiter="${1}"
    local -r array=("${@:2}")

    printf "%s${delimiter}" "${array[@]}"
}

function sortUniqArray()
{
    local -r array=("${@}")

    echo "${result}" | sort | uniq
}
