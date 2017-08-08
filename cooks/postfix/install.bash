#!/bin/bash -e

function installDependencies()
{
    installPackages "${POSTFIX_DEPENDENCIES_PACKAGES[@]}"
}


function main()
{
    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${appFolderPath}/../../libraries/Utils.bash"
    source "${appFolderPath}/default.bash"

    checkRequireLinuxSystem
    checkRequireRootUser

    header 'INSTALLING POSTFIX FROM SOURCE'
    installDependencies
}

main "${@}"