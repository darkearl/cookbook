#!/bin/bash -e

function installDependencies()
{
    installPackages "${NGINX_DEPENDENCIES_PACKAGES[@]}"
}

function install()
{
    umask '0022'
    # Download Dependencies
    local -r tempPCREFolder="$(getTemporaryFolder)"
    unzipRemoteFile "${NGINX_PCRE_DOWNLOAD_URL}" "${tempPCREFolder}"
    
    # Enhanced Nginx Memcached Module
    # https://github.com/bpaquet/ngx_http_enhanced_memcached_module
    local -r tempMHEMFolder="$(getTemporaryFolder)"
    git clone "${NGINX_MODULE_HTTP_ENHANCED_MEMCACHED}" "${tempMHEMFolder}"
    chmod 777 -R ${tempMHEMFolder}

    # Install
    local -r tempFolder="$(getTemporaryFolder)"
    unzipRemoteFile "${NGINX_DOWNLOAD_URL}" "${tempFolder}"

    # Configure before build
    cd "${tempFolder}"
    "${tempFolder}/configure" \
        "${NGINX_CONFIG[@]}" \
        --with-pcre="${tempPCREFolder}" \
        --add-module="${tempMHEMFolder}"
    make
    make install

    # Remove tmp folder
    rm -f -r "${tempFolder}" "${tempPCREFolder}" "${tempMHEMFolder}"

    # Display Version
    displayVersion "$("${NGINX_SBIN_PATH}" -V 2>&1)"

    umask '0077'
}

function main()
{
    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${appFolderPath}/../../libraries/Utils.bash"
    source "${appFolderPath}/default.bash"

    checkRequireLinuxSystem
    checkRequireRootUser

    header 'INSTALLING NGINX FROM SOURCE'
    installDependencies
    install
    # installCleanUp
}

main "${@}"