FROM ubuntu:latest
MAINTAINER Michael Vorburger <mvorburger@temenos.com>

ADD . /build
RUN /build/prepare.sh

CMD ["java -jar hudson.war"]

# Run Hudson once during image creation, so that it's faster first time
# RUN java -jar hudson.war

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

