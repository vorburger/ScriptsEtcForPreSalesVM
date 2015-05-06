build.sh

docker run -p 8080:8080 -p 3690:3690 dsdemo
...
docker stop ...
docker ps -a
...
docker start ...
docker exec -it bash

NOTE: You probably do *NOT* mean to "docker run" again, as that will create _another_ Container of the same Image.

Inspired partially by https://github.com/phusion/baseimage-docker;
note in particular what it says re. docker exec bash vs. sshd etc.

Caveat emptor: The documentation and scripts in this Git repository are provided "as is",
just a how-to example, and not an officially supported "product" by 
TEMENOS The Banking Software Company.  See LICENSE.txt

Originally created by Michael Vorburger on April 29th, 2015.


