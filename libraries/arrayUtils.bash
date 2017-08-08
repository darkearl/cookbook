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

    local -r string="$(printf "%s${delimiter}" "${array[@]}")"

    echo "${string:0:${#string} - ${#delimiter}}"
}

function sortUniqArray()
{
    local -r array=("${@}")

    echo "${result}" | sort | uniq
}
