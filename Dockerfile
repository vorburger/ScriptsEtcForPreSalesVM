FROM java:7
# Using java:7 builds faster than using ubuntu:latest and adding openjdk-7-jdk ourselves
# BUT it's bigger as it include bzr, Perl, Python, which we don't actually need..
# Also this is OpenJDK, OK for dev; but for a production image with Oracle JDK,
# you may wish to use sth. like https://github.com/gratiartis/dockerfiles/blob/master/oraclejdk8/Dockerfile.

MAINTAINER Michael Vorburger <mvorburger@temenos.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
# Workaround for https://github.com/docker/docker/issues/9299
ENV TERM xterm

# Do apt stuff here, not in the prepare.sh, so that Docker can cache this part!
# https://docs.docker.com/articles/dockerfile_best-practices/ :
# Avoid RUN apt-get upgrade or apt-get dist-upgrade -y --no-install-recommends
# Don’t do RUN apt-get update on a single line  (but along with apt-get install)
RUN DEBIAN_FRONTEND=noninteractive \
   apt-get update && apt-get install -y --no-install-recommends \
       	nano \
        psmisc \
        unzip \
        supervisor \
        subversion \
   && apt-get autoremove && apt-get autoclean && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

# Use COPY for local files & directories
# and ADD for both local as well as http://... *.tar file auto-extraction into the image
# NOTE To unpack a compressed archive, the destination directory must end with a trailing slash
# NOTE Only *.tar.gz seem to work for ADD, not *.zip :(
COPY . /build
ADD Downloads/apache-maven-3.3.3-bin.tar.gz /root/
RUN /build/prepare.sh

# TODO VOLUME for where the stuff to keep is

# CMD ["java", "-jar", "/root/Jenkins/jenkins.war"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 8080
EXPOSE 3690
