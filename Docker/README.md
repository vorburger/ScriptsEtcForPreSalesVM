build.sh

docker run -itp 8080:8080 dsdemo
docker ps -a
...
docker start -ia ...

NOTE: You probably do *NOT* mean to "docker run" again, as that will create _another_ Container of the same Image.

Inspired parially by https://github.com/phusion/baseimage-docker

Originally created by Michael Vorburger on April 29th, 2015.


