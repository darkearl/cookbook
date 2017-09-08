#!/bin/bash -e

####################
# SYSTEM UTILITIES #
####################


function checkRequireRootUser()
{
    checkRequireUserLogin 'root'
}

function checkRequireUserLogin()
{
    local -r userLogin="${1}"

    if [[ "$(whoami)" != "${userLogin}" ]]
    then
        fatal "User login '${userLogin}' required"
    fi
}

function checkRequireLinuxSystem()
{
    if [[ "$(isUbuntuDistributor)" = 'false' ]]
    then
        fatal "Only support Ubuntu OS!"
    fi
}

# is Ubuntu OS
function isUbuntuDistributor()
{
    isDistributor 'Ubuntu'
}

# GET NAME OS
function isDistributor()
{
    local -r distributor="${1}"

    local -r found="$(grep -F -i -o -s "${distributor}" '/proc/version')"

    if [[ "$(isEmptyString "${found}")" = 'true' ]]
    then
        echo 'false'
    else
        echo 'true'
    fi
}

function getTemporaryFolder()
{
    mktemp -d "$(getTemporaryFolderRoot)/$(date +'%Y%m%d-%H%M%S')-XXXXXXXXXX"
}

function getTemporaryFolderRoot()
{
    local temporaryFolder='/tmp'

    if [[ "$(isEmptyString "${TMPDIR}")" = 'false' ]]
    then
        temporaryFolder="$(formatPath "${TMPDIR}")"
    fi

    echo "${temporaryFolder}"
}

function existCommand()
{
    local -r command="${1}"

    if [[ "$(which "${command}" 2> '/dev/null')" = '' ]]
    then
        echo 'false'
    else
        echo 'true'
    fi
}