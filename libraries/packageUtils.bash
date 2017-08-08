#!/bin/bash -e


#####################
# PACKAGE UTILITIES #
#####################


function installPackage()
{
    local -r aptPackage="${1}"
    local -r rpmPackage="${2}"

    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        installAptGetPackage "${aptPackage}"
    else
        fatal 'only support Ubuntu OS'
    fi
}

function installPackages()
{
    local -r packages=("${@}")

    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        runAptGetUpdate ''
    fi

    local package=''

    for package in "${packages[@]}"
    do
        if [[ "$(isUbuntuDistributor)" = 'true' ]]
        then
            installAptGetPackage "${package}"
        else
            fatal 'Only support Ubuntu OS'
        fi
    done
}

function installAptGetPackage()
{
    local -r package="${1}"

    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        if [[ "$(isAptGetPackageInstall "${package}")" = 'true' ]]
        then
            debug "Apt-Get Package '${package}' has already been installed"
        else
            warn "Installing Apt-Get Package '${package}'"
            DEBIAN_FRONTEND='noninteractive' apt-get install "${package}" --fix-missing -y
        fi
    fi
}

function runAptGetUpdate()
{
    local updateInterval="${1}"

    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        local -r lastAptGetUpdate="$(getLastAptGetUpdate)"

        if [[ "$(isEmptyString "${updateInterval}")" = 'true' ]]
        then
            # Default To 24 hours
            updateInterval="$((24 * 60 * 60))"
        fi

        if [[ "${lastAptGetUpdate}" -gt "${updateInterval}" ]]
        then
            warn 'apt-get update'
            apt-get update -m
        else
            local -r lastUpdate="$(date -u -d @"${lastAptGetUpdate}" +'%-Hh %-Mm %-Ss')"

            warn "Skip apt-get update because its last run was '${lastUpdate}' ago"
        fi
    fi
}

function getLastAptGetUpdate()
{
    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        local -r aptDate="$(stat -c %Y '/var/cache/apt')"
        local -r nowDate="$(date +'%s')"

        echo $((nowDate - aptDate))
    fi
}

function isAptGetPackageInstall()
{
    local -r package="$(escapeGrepSearchPattern "${1}")"

    local -r found="$(dpkg --get-selections | grep -E -o "^${package}(:amd64)*\s+install$")"

    if [[ "$(isEmptyString "${found}")" = 'true' ]]
    then
        echo 'false'
    else
        echo 'true'
    fi
}

function installBZip2Command()
{
    local -r commandPackage=('bzip2' 'bzip2')

    installCommands "${commandPackage[@]}"
}

function installUnzipCommand()
{
    local -r commandPackage=('unzip' 'unzip')

    installCommands "${commandPackage[@]}"
}

function installTarCommand()
{
    local -r commandPackage=('tar' 'tar')

    installCommands "${commandPackage[@]}"
}

function installCURLCommand()
{
    local -r commandPackage=('curl' 'curl')

    installCommands "${commandPackage[@]}"
}

function installWgetCommand()
{
    local -r commandPackage=('wget' 'wget')

    installCommands "${commandPackage[@]}"
}

function installCommands()
{
    local -r data=("${@}")

    if [[ "$(isUbuntuDistributor)" = 'true' ]]
    then
        runAptGetUpdate ''
    fi

    local i=0

    for ((i = 0; i < ${#data[@]}; i = i + 2))
    do
        local command="${data[${i}]}"
        local package="${data[${i} + 1]}"

        checkNonEmptyString "${command}" 'undefined command'
        checkNonEmptyString "${package}" 'undefined package'

        if [[ "$(existCommand "${command}")" = 'false' ]]
        then
            installPackages "${package}"
        else
            debug "Command '${command}' has already been installed"
        fi
    done
}