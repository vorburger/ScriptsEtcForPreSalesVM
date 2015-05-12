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

# Another Windows/Linux cross platform issue.. it's wrong to catch up one-by-one; the package used should use the TAFJ Maven plug-in to create the TAFJ home instead :(
sed -i 's/Primary.jar;/Primary.jar:/g' $1/TAFJ/conf/tafj.properties

# https://github.com/temenostech/Hothouse/issues/162 is *STILL* NOK :-(
mv $1/jboss/modules/com/temenos/t24/main/Module.xml $1/jboss/modules/com/temenos/t24/main/module.xml
