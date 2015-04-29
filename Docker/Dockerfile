FROM ubuntu:latest
MAINTAINER Michael Vorburger <mvorburger@temenos.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

COPY . /build
RUN /build/prepare.sh

# Use ADD for both local as well as http://... *.tar file auto-extraction into the image
# ADD *.tar.gz / 

# TODO VOLUME for where the stuff to keep is

# CMD ["java -jar hudson.war"]
# EXPOSE

