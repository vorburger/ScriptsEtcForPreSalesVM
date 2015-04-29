#!/bin/bash
set -e
set -x

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
minimal_apt_get_install='apt-get install -y --no-install-recommends'

apt-get dist-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends nano psmisc

## Fix locale.
# $minimal_apt_get_install language-pack-en
# locale-gen en_US
# update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
# echo -n en_US.UTF-8 > /etc/container_environment/LANG
# echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE

# Run Hudson once during image creation, so that it's faster first time
# RUN java -jar hudson.war

# Clean up APT when done.
apt-get clean
# rm -rf /var/lib/apt/lists/*

rm -rf /build
rm -rf /tmp/* /var/tmp/*
