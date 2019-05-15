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
RUN apt-get install -y curl apt-transport-https
RUN curl https://packages.icinga.com/icinga.key | apt-key add -
RUN printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\n" > /etc/apt/sources.list.d/icinga2.list
RUN printf "deb-src http://packages.icinga.com/ubuntu icinga-bionic main\n" >> /etc/apt/sources.list.d/icinga2.list
RUN apt-get update && apt-get install -y icinga2 icinga2-ido-mysql  icinga2-ido-pgsql monitoring-plugins
RUN if [ "$ENABLE_INFLUXDB" == "yes" ]; then icinga2 feature enable influxdb; fi ;\
    if [ "$ENABLE_DIRECTOR" == "yes" ]; then icinga2 feature enable director; fi ;\
    if [ "$ENABLE_API" == "yes" ]; then icinga2 feature enable api; fi ;\
    if [ "$ENABLE_CHECKER" == "yes" ]; then icinga2 feature enable checker; fi ;\
    if [ "$ENABLE_MAINLOG" == "yes" ]; then icinga2 feature enable mainlog; fi ;\
    if [ "$ENABLE_NOTIFICATION" == "yes" ]; then icinga2 feature enable notification; fi \
    if [ "$ENABLE_COMMAND" == "yes" ]; then icinga2 feature enable command; fi ;\
    if [ "$ENABLE_COMPATLOG" == "yes" ]; then icinga2 feature enable compatlog; fi ;\
    if [ "$ENABLE_DEBUGLOG" == "yes" ]; then icinga2 feature enable debuglog; fi ;\
    if [ "$ENABLE_GELF" == "yes" ]; then icinga2 feature enable gelf; fi ;\
    if [ "$ENABLE_GRAPHITE" == "yes" ]; then icinga2 feature enable graphite; fi ;\
    if [ "$ENABLE_ICINGASTATUS" == "yes" ]; then icinga2 feature enable icingastatus; fi ;\
    if [ "$ENABLE_IDO-MYSQL" == "yes" ]; then icinga2 feature enable ido-mysql; fi ;\
    if [ "$ENABLE_IDO-PGSQL" == "yes" ]; then icinga2 feature enable ido-pgsql; fi ;\
    if [ "$ENABLE_LIVESTATUS" == "yes" ]; then icinga2 feature enable livestatus; fi ;\
    if [ "$ENABLE_OPENTSDB" == "yes" ]; then icinga2 feature enable opentsdb; fi ;\
    if [ "$ENABLE_PERFDATA" == "yes" ]; then icinga2 feature enable perfdata; fi ;\
    if [ "$ENABLE_STATUSDATA" == "yes" ]; then icinga2 feature enable statusdata; fi
