FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
ENV ENABLE_INFLUXDB="yes"
ENV ENABLE_DIRECTOR="yes"
ENV ENABLE_API="yes"
ENV ENABLE_CHECKER="yes"
ENV ENABLE_MAINLOG="yes"
ENV ENABLE_NOTIFICATION="yes"
ENV ENABLE_COMMAND="yes"
ENV ENABLE_COMPATLOG="no"
ENV ENABLE_DEBUGLOG="no"
ENV ENABLE_GELF="no"
ENV ENABLE_GRAPHITE="no"
ENV ENABLE_IDO-MYSQL="yes"
ENV ENABLE_IDO-PGSQL="no"
ENV ENABLE_LIVESTATUS="no"
ENV ENABLE_OPENTSDB="no"
ENV ENABLE_PERFDATA="yes"
ENV ENABLE_STATUSDATA="yes"
ENV ENABLE_SYSLOG="no"
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl apt-transport-https gnupg
RUN curl https://packages.icinga.com/icinga.key | apt-key add -
RUN printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\n" > /etc/apt/sources.list.d/icinga2.list
RUN printf "deb-src http://packages.icinga.com/ubuntu icinga-bionic main\n" >> /etc/apt/sources.list.d/icinga2.list
RUN apt-get update && apt-get install -y icinga2 icinga2-ido-mysql  icinga2-ido-pgsql monitoring-plugins supervisor
RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /supervisord.conf
RUN chmod 755 /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
