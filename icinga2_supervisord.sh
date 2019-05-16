#!/bin/bash
service icinga2 foreground & sleep 5 &&
# Allow any signal which would kill a process to stop server
trap "service icinga2 stop" HUP INT QUIT ABRT ALRM TERM TSTP
#while pgrep -u nagios icinga2 > /dev/null; do sleep 5; done
while pgrep -u nagios icinga2 > /dev/null; do sleep 5; done
