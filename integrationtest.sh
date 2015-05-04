#!/bin/bash
set -e
set -x

# TODO Could change this to just use:
# /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &
#    ...
# kill $!

# Run Hudson once during image creation, so that it's faster first time, AND we can TDD!
# Alternative: nohup java -jar jenkins.war > $LOGFILE 2>&1
java -jar /root/Jenkins/jenkins.war &

# Run SVN server, needed by Hudson to check-out
# We MUST start this after Jenkins, to use $! below
svnserve -d --foreground -r /root/DemoSVNServer &

# We need to wait to let Jenkins actually start up
until [ "`curl --silent --show-error --connect-timeout 1 -I http://localhost:8080/cli | grep '302 Found'`" != "" ];
do
  sleep 5
done

# Now lets build our Job, and fail if that doesn't work
wget http://localhost:8080/jnlpJars/jenkins-cli.jar -P /tmp
java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ build DemoBuildPackage -f -s -v -w

# Shutdown Jenkins (remember this runs from Dockerfile; supervisor hasn't started, yet)
java -jar /tmp/jenkins-cli.jar -s http://localhost:8080/ shutdown

# Shutdown SVN (via its PID, as its the last started background process) 
kill $!
