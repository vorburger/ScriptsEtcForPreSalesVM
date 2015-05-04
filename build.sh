#!/bin/bash
set -e
set -x

cd Downloads/
wget -cN http://mirrors.jenkins-ci.org/war/latest/jenkins.war
wget -cN http://mirror.switch.ch/mirror/apache/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
wget -cN -r -l1 "http://p2.oams.com/dist/latest/master/" -A "t24-binaries*.zip"
# TODO where to internally download sth. like base_mb_t24brpdev_7.tar.gz from??
cd -

docker build -t dsdemo .

