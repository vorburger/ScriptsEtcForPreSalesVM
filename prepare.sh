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

# Create sample project from DS template and stick it into SVN
# TODO Why is plugin version 1.0.4 hard-coded required here, it doesn't work without, but not in
#    https://github.com/TemenosDS/DS/blob/master/t24-binaries/build-t24binaries.xml ?
# MINOR Does not work -o offline, because not all dependencies of maven-template-plugin are in repo.. :(
/root/apache-maven-3.3.3/bin/mvn com.odcgroup.maven.plugin:maven-template-plugin:1.0.4:generate \
	-DtemplateGroupId=com.temenos.ds.t24-template -DtemplateArtifactId=t24-packager-tafj \
	-DinteractiveMode=false -Dtarget=/tmp/ProjectsFromTemplate \
	-DtemplateVersion=2015.06.0-SNAPSHOT
svn import --username developer1 --password developer1 /tmp/ProjectsFromTemplate \
	file://$PWD/DemoSVNServer/t24-packager-tafj/ \
	-m "Initial commit of projects created from t24-packager-tafj template"

# Set up Supervisor
mkdir -p /var/log/supervisor
cp /build/Common/Supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up
rm -rf /build
rm -rf /tmp/* /var/tmp/*
