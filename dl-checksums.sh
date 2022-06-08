#!/usr/bin/env sh
#set -x
set -e
DIR=~/Downloads
MIRROR=https://github.com/dragonflyoss
APP=Dragonfly2

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}-${arch}"
    local file="${APP}-${ver}-${platform}.${archive_type}"
    local url=$MIRROR/$APP/releases/download/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="${APP}_${ver}_checksums.txt"
    # https://github.com/dragonflyoss/Dragonfly2/releases/download/v2.0.1/checksums.txt
    local url=$MIRROR/$APP/releases/download/v$ver/checksums.txt
    local lchecksums="${DIR}/${checksums}"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums linux amd64
}

dl_ver ${1:-2.0.3}
