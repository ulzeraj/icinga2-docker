FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl apt-transport-https gnupg
RUN curl https://packages.icinga.com/icinga.key | apt-key add -
RUN printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\n" > \
    /etc/apt/sources.list.d/icinga2.list
RUN printf "deb-src http://packages.icinga.com/ubuntu icinga-bionic main\n" >> \
    /etc/apt/sources.list.d/icinga2.list
RUN apt-get update && apt-get install -y icinga2 icinga2-ido-mysql mailutils \
    icinga2-ido-pgsql monitoring-plugins supervisor mailutils
RUN apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN mkdir -p /run/icinga2/cmd
RUN /usr/lib/icinga2/prepare-dirs
COPY supervisord.conf /supervisord.conf
COPY icinga2_supervisord.sh /icinga2_supervisord.sh
COPY cmd.sh /cmd.sh
RUN chmod 755 /cmd.sh /icinga2_supervisord.sh
CMD ["/cmd.sh"]
