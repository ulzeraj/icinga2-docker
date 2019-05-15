FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
ARG ENABLE_INFLUXDB="yes"
ARG ENABLE_DIRECTOR="yes"
ARG ENABLE_API="yes"
ARG ENABLE_CHECKER="yes"
ARG ENABLE_MAINLOG="yes"
ARG ENABLE_NOTIFICATION="yes"
ARG ENABLE_COMMAND="yes"
ARG ENABLE_COMPATLOG="no"
ARG ENABLE_DEBUGLOG="no"
ARG ENABLE_GELF="no"
ARG ENABLE_GRAPHITE="no"
ARG ENABLE_ICINGASTATUS="yes"
ARG ENABLE_IDO-MYSQL="yes"
ARG ENABLE_IDO-PGSQL="no"
ARG ENABLE_LIVESTATUS="no"
ARG ENABLE_OPENTSDB="no"
ARG ENABLE_PERFDATA="yes"
ARG ENABLE_STATUSDATA="yes"
ARG ENABLE_SYSLOG="no"
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl apt-transport-https gnupg
RUN curl https://packages.icinga.com/icinga.key | apt-key add -
RUN printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\n" > /etc/apt/sources.list.d/icinga2.list
RUN printf "deb-src http://packages.icinga.com/ubuntu icinga-bionic main\n" >> /etc/apt/sources.list.d/icinga2.list
RUN apt-get update && apt-get install -y icinga2 icinga2-ido-mysql  icinga2-ido-pgsql monitoring-plugins 
COPY entrypoint.sh /entrypoint.sh
COPY cmd.sh /cmd.sh
RUN chmod 755 /entrypoint.sh /cmd.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
