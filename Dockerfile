FROM ubuntu:latest
# or OpenJDK: FROM java:7 <= This will be Debian base instead ubuntu
# Using java:7 builds faster than using ubuntu:latest and adding openjdk-7-jdk or Oracle JDK ourselves
# BUT it's bigger as it include bzr, Perl, Python, which we don't actually need..

MAINTAINER Michael Vorburger <mvorburger@temenos.com>

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
# Workaround for https://github.com/docker/docker/issues/9299
ENV TERM xterm

# Do apt stuff here, not in the prepare.sh, so that Docker can cache this part!
# https://docs.docker.com/articles/dockerfile_best-practices/ :
# Avoid RUN apt-get upgrade or apt-get dist-upgrade -y --no-install-recommends
# Don’t do RUN apt-get update on a single line  (but along with apt-get install)
# Do NOT use DEBIAN_FRONTEND=noninteractive, as per http://docs.docker.com/faq/
# For Oracle JDK v7 instead of OpenJDK:
RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y --no-install-recommends \
        nano \
        curl \
        psmisc \
        unzip \
        supervisor \
        subversion \
        openssh-server \
        oracle-java7-installer \
   && apt-get autoremove && apt-get autoclean && apt-get clean

# Do NOT \ && rm -rf /var/lib/apt/lists/* (as other Dockerfile sometimes do),
# because saving a few bits here but then not being able to install additional
# packages during run-time (useful for debugging sometimes) is more pain than gain.

# This is needed for the TAFj/bin scripts who use ksh
RUN ln -s /bin/bash /bin/ksh

# Use COPY for local files & directories
# and ADD for both local as well as http://... *.tar file auto-extraction into the image
# NOTE To unpack a compressed archive, the destination directory must end with a trailing slash
# NOTE Only *.tar.gz seem to work for ADD, not *.zip :(
COPY . /build
ADD Downloads/apache-maven-3.0.4-bin.tar.gz /root/
COPY Downloads/Temenos /root/Temenos

# NOTE: Any new ENV here must also be added in the RUN echo section below..
ENV JAVA_HOME  /usr/lib/jvm/java-7-oracle
ENV M2_HOME    /root/apache-maven-3.0.4/
ENV T24MB_HOME /root/Temenos
ENV TAFJ_HOME  $T24MB_HOME/TAFJ
ENV JBOSS_HOME $T24MB_HOME/jboss
ENV PATH       $TAFJ_HOME/bin:$M2_HOME/bin:$PATH

# Set-up sshd, as per https://docs.docker.com/examples/running_ssh_service/
RUN mkdir /var/run/sshd
RUN echo 'root:demo' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# as explained on the docker.com doc page page, we need to REPEAT all of our ENV here
RUN echo "# https://docs.docker.com/examples/running_ssh_service/" >>/etc/profile
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile
RUN echo "export M2_HOME=${M2_HOME}" >> /etc/profile
RUN echo "export T24MB_HOME=${T24MB_HOME}" >> /etc/profile
RUN echo "export TAFJ_HOME=${TAFJ_HOME}" >> /etc/profile
RUN echo "export JBOSS_HOME=${JBOSS_HOME}" >> /etc/profile
RUN echo "export PATH=${PATH}" >> /etc/profile

RUN /build/prepare.sh
# RUN /build/integrationtest.sh
RUN rm -rf /build /tmp/* /var/tmp/*

# TODO VOLUME for where the stuff to keep is

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# 2222 = SSHd ssh://
EXPOSE 2222

# 8080 = Jenkins http://
EXPOSE 8080

# 3690 = Subversion svn://
EXPOSE 3690

# 9001 = Supervisor http://
EXPOSE 9001

# 9089 = JBoss T24 BrowserWeb etc. http://
EXPOSE 9089

# 10999 = JBoss Management UI http://
EXPOSE 10999

# 8787 = JBoss JVM default debugging port for remote attaching
EXPOSE 8787
