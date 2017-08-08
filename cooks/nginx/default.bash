#!/bin/bash -e

export NGINX_PCRE_DOWNLOAD_URL="http://downloads.sourceforge.net/pcre/pcre-8.41.tar.bz2"

#https://nginx.org/en/download.html
export NGINX_DOWNLOAD_URL="http://nginx.org/download/nginx-1.12.1.tar.gz"

export NGINX_MODULE_HTTP_ENHANCED_MEMCACHED="git://github.com/bpaquet/ngx_http_enhanced_memcached_module.git"

export NGINX_DEPENDENCIES_PACKAGES=(
    'build-essential'
    'libc6'
    'libpcre3'
    'libpcre3-dev'
    'libpcrecpp0'
    'libssl0.9.8'
    'libssl-dev'
    'zlib1g'
    'zlib1g-dev'
    'lsb-base'
    'openssl'
    'libssl-dev'
    'libgeoip1'
    'libgeoip-dev'
    'google-perftools'
    'libgoogle-perftools-dev'
    'libperl-dev'
    'libgd2-xpm-dev'
    'libatomic-ops-dev'
    'libxml2-dev'
    'libxslt1-dev'
    'python-dev'
)

export NGINX_SBIN_PATH="/usr/sbin/nginx"
export NGINX_CONFIG=(
    '--user=nginx'
    '--group=nginx'
    "--sbin-path=${NGINX_SBIN_PATH}"
    '--conf-path=/etc/nginx/nginx.conf'
    '--error-log-path=/var/log/nginx/error.log'
    '--http-log-path=/var/log/nginx/access.log'
    '--pid-path=/var/run/nginx.pid'
    '--with-select_module'
    '--with-poll_module'
    '--with-file-aio'
    '--with-http_ssl_module'
    '--with-http_realip_module'
    '--with-http_addition_module'
    '--with-http_xslt_module'
    '--with-http_image_filter_module'
    '--with-http_geoip_module'
    '--with-http_sub_module'
    '--with-http_dav_module'
    '--with-http_flv_module'
    '--with-http_mp4_module'
    '--with-http_gunzip_module'
    '--with-http_gzip_static_module'
    '--with-http_auth_request_module'
    '--with-http_random_index_module'
    '--with-http_secure_link_module'
    '--with-http_degradation_module'
    '--with-http_stub_status_module'
    '--with-http_perl_module'
    '--with-mail'
    '--with-mail_ssl_module'
    '--with-cpp_test_module'
    '--with-cpu-opt=CPU'
    '--with-pcre-jit'
    '--with-zlib-asm=CPU'
    '--with-libatomic'
    '--with-debug'
)

