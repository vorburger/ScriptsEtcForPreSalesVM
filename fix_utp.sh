#!/bin/bash
set -e
set -x

rm -rf Temenos/EDS
rm -rf Temenos/Java

chmod +x $1/jboss/bin/*.sh

# rm $1/TAFJ/bin/*.bat
chmod +x $1/TAFJ/bin/*
dos2unix $1/TAFJ/bin/*

# https://github.com/temenostech/Hothouse/issues/987 is *STILL* NOK :-(
sed -i 's/\\/\//g' $1/TAFJ/conf/tafj.properties

# https://github.com/temenostech/Hothouse/issues/162 is *STILL* NOK :-(
mv $1/jboss/modules/com/temenos/t24/main/Module.xml $1/jboss/modules/com/temenos/t24/main/module.xml
