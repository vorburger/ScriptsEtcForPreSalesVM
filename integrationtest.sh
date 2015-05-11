#!/bin/bash
set -e
set -x

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &

# We need to wait to let Jenkins actually start up
until [ "`curl --silent --show-error --connect-timeout 1 -I http://localhost:7070/cli | grep '302 Found'`" != "" ];
do
  sleep 5
done

# Now lets build our Job, and fail if that doesn't work
wget http://localhost:7070/jnlpJars/jenkins-cli.jar -P /tmp
java -jar /tmp/jenkins-cli.jar -s http://localhost:7070/ build DemoBuildPackage -f -s -v -w
java -jar /tmp/jenkins-cli.jar -s http://localhost:7070/ build DemoDeployPackage -f -s -v -w

# Shutdown SupervisorD (via its PID, as its the last started background process)
# This will in turn of course shut down Jenkins, SVN etc.
kill $!
