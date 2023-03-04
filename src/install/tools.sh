#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common tools for further installation"
apt-get update
#used for websockify/novnc
apt-get install -y \
    git curl vim gedit wget net-tools locales bzip2 procps terminator \
    python3-numpy
apt-get clean -y

# set language
echo "generate locales en_US.UTF-8"
locale-gen en_US.UTF-8
