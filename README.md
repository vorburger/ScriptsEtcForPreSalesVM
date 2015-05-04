build.sh

docker run -p 8080:8080 dsdemo
...
docker stop ...
docker ps -a
...
docker start ...
docker exec -it bash

NOTE: You probably do *NOT* mean to "docker run" again, as that will create _another_ Container of the same Image.

Inspired parially by https://github.com/phusion/baseimage-docker

Originally created by Michael Vorburger on April 29th, 2015.


