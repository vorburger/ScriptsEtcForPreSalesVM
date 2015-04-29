#!/bin/bash
set -e
set -x

cd Downloads
wget -cN http://mirrors.jenkins-ci.org/war/latest/jenkins.war
cd ..

docker build -t dsdemo .

