FROM java:7
# Using java:7 builds faster than using ubuntu:latest and adding openjdk-7-jdk ourselves
# BUT it's bigger as it include bzr, Perl, Python, which we don't actually need..
# Also this is OpenJDK, OK for dev; but for a production image with Oracle JDK,
# you may wish to use sth. like https://github.com/gratiartis/dockerfiles/blob/master/oraclejdk8/Dockerfile.

MAINTAINER Michael Vorburger <mvorburger@temenos.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

COPY . /build
RUN /build/prepare.sh

# Use ADD for both local as well as http://... *.tar file auto-extraction into the image
# ADD *.tar.gz / 

# TODO VOLUME for where the stuff to keep is

CMD ["java", "-jar", "/root/Jenkins/jenkins.war"]
EXPOSE 8080

