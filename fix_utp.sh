#!/bin/bash
set -e
set -x

chmod +x $1/jboss/bin/*.sh

# rm $1/TAFJ/bin/*.bat
chmod +x $1/TAFJ/bin/*
dos2unix $1/TAFJ/bin/*

sed -i 's/\\/\//g' $1/TAFJ/conf/tafj.properties

