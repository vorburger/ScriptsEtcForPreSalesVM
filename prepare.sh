#!/bin/bash
set -e
set -x

export LC_ALL=C

# Fix locale.
# $minimal_apt_get_install language-pack-en
# locale-gen en_US
# update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
# echo -n en_US.UTF-8 > /etc/container_environment/LANG
# echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE

# Now finally the real stuff.. ;-)
# Set up Jenkins
mkdir /root/Jenkins
# curl -L http://mirrors.jenkins-ci.org/war/latest/jenkins.war -o /root/Jenkins/jenkins.war 
mv /build/Downloads/jenkins.war /root/Jenkins/jenkins.war
# Run Hudson once during image creation, so that it's faster first time?
# RUN java -jar hudson.war

# Set up Maven
mv /build/Common/Maven/settings.xml /root/apache-maven-3.3.3/conf/
# Set up Maven repository
mkdir -p /root/.m2/repository/ && \
	mv /build/Downloads/p2.oams.com/dist/latest/master/t24-binaries*.zip /root/.m2/repository/ && \
	cd /root/.m2/repository/ && unzip t24-binaries*.zip && rm /root/.m2/repository/t24-binaries*.zip

# Set up SVN
cd /root/
svnadmin create DemoSVNServer
mv /build/Common/Subversion/svnserve.conf /root/DemoSVNServer/conf/
mv /build/Common/Subversion/passwds /root/DemoSVNServer/conf/

# Set up Supervisor
mkdir -p /var/log/supervisor
cp /build/Common/Supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up
rm -rf /build
rm -rf /tmp/* /var/tmp/*
