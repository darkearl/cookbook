#!/bin/bash -e

export NGINX_PCRE_DOWNLOAD_URL="http://downloads.sourceforge.net/pcre/pcre-8.41.tar.bz2"

#https://nginx.org/en/download.html
export NGINX_DOWNLOAD_URL="http://nginx.org/download/nginx-1.13.3.tar.gz"

export NGINX_MODULE_HTTP_ENHANCED_MEMCACHED="git://github.com/bpaquet/ngx_http_enhanced_memcached_module.git"

NPS_VERSION="1.12.34.2"
export NGINX_MODULE_NGX_PAGESPEED="https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}-stable.zip"

export NGINX_MODULE_NGX_PAGESPEED_PSOL="https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}-ia32.tar.gz"

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
"--sbin-path=/usr/sbin/nginx"
"--prefix=/usr/share/nginx"
"--conf-path=/etc/nginx/nginx.conf"
"--http-log-path=/var/log/nginx/access.log"
"--error-log-path=/var/log/nginx/error.log"
"--lock-path=/var/lock/nginx.lock"
"--pid-path=/run/nginx.pid"
"--modules-path=/usr/lib/nginx/modules"
"--http-client-body-temp-path=/var/lib/nginx/body"
"--http-fastcgi-temp-path=/var/lib/nginx/fastcgi"
"--http-proxy-temp-path=/var/lib/nginx/proxy"
"--http-scgi-temp-path=/var/lib/nginx/scgi"
"--http-uwsgi-temp-path=/var/lib/nginx/uwsgi"
"--with-debug"
"--with-pcre-jit"
"--with-http_ssl_module"
"--with-http_stub_status_module"
"--with-http_realip_module"
"--with-http_auth_request_module"
"--with-http_v2_module"
"--with-http_dav_module"
"--with-http_slice_module"
"--with-threads"
"--with-http_addition_module"
"--with-http_geoip_module=dynamic"
"--with-http_gunzip_module"
"--with-http_gzip_static_module"
"--with-http_image_filter_module=dynamic"
"--with-http_sub_module"
"--with-http_xslt_module=dynamic"
"--with-stream=dynamic"
"--with-stream_ssl_module"
"--with-stream_ssl_preread_module"
"--with-mail=dynamic"
"--with-mail_ssl_module"
)

