#!/bin/bash -e

####################
# CONSTANST        #
####################
ESC_SEQ="\x1b["
COLOR_GREEN=$ESC_SEQ"32;01m"
COLOR_RED=$ESC_SEQ"31;01m"
COLOR_YELLOW=$ESC_SEQ"33;01m"
COLOR_RESET=$ESC_SEQ"39;49;00m"
COLOR_PINK=$ESC_SEQ"1;49;35m"
COLOR_BLUE=$ESC_SEQ"1;34m"
COLOR_BLUE_SKY=$ESC_SEQ"1;36m"

####################
# STRING UTILITIES #
####################

function checkNonEmptyString()
{
    local -r string="${1}"
    local -r errorMessage="${2}"

    if [[ "$(isEmptyString "${string}")" = 'true' ]]
    then
        if [[ "$(isEmptyString "${errorMessage}")" = 'true' ]]
        then
            fatal 'empty value detected'
        fi

        fatal "${errorMessage}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true'
    else
        echo 'false'
    fi
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function warn()
{
    local -r message="${1}"

    echo -e "\n${COLOR_YELLOW}${message}${COLOR_RESET}" 1>&2
}

function error()
{
    local -r message="${1}"
    echo -e "\n${COLOR_RED}${message}${COLOR_RESET}" 1>&2
}

function header()
{
    local -r title="${1}"

    echo -e "\n${COLOR_YELLOW}>>>>>>>>>> ${COLOR_PINK}${title}${COLOR_YELLOW} <<<<<<<<<<${COLOR_RESET}"
}

function escapeGrepSearchPattern()
{
    local -r searchPattern="${1}"

    sed 's/[]\.|$(){}?+*^]/\\&/g' <<< "${searchPattern}"
}

function fatal()
{
    local -r message="${1}"

    error "FATAL : ${message}"
    exit 1
}

function debug()
{
    local -r message="${1}"

    echo -e "\n${COLOR_BLUE}${message}${COLOR_RESET}" 2>&1
}

function info()
{
    local -r message="${1}"

    echo -e "\n${COLOR_BLUE_SKY}${message}${COLOR_RESET}" 2>&1
}
function formatPath()
{
    local path="${1}"

    while [[ "$(grep -F '//' <<< "${path}")" != '' ]]
    do
        path="$(sed -e 's/\/\/*/\//g' <<< "${path}")"
    done

    sed -e 's/\/$//g' <<< "${path}"
}

function checkTrueFalseString()
{
    local -r string="${1}"

    if [[ "${string}" != 'true' && "${string}" != 'false' ]]
    then
        fatal "'${string}' is not 'true' or 'false'"
    fi
}
function displayVersion()
{
    local -r message="${1}"

    header 'DISPLAYING VERSION'
    info "${message}"
}

function prompt_user(){
    variable=$1
    prompt=$2
    default_value=$3

    if [ -z "$variable" ]; then
        echo "Variable name was not given!" && exit 1
    fi

    read -p "$prompt [$default_value]: " $variable

    if [ -z "${!variable}" ]; then
        eval "$variable=$default_value"
    fi

}