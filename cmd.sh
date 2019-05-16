#!/bin/bash
if [ "$ENABLE_INFLUXDB" == "yes" ]; then 
    icinga2 feature enable influxdb 
    sed -i "s/\(^host = \).*/\1\"${INFLUXDB_HOST}\"/" /etc/icinga2/features-enabled/influxdb.conf
    sed -i "s/\(^port = \).*/\1\"${INFLUXDB_PORT}\"/" /etc/icinga2/features-enabled/influxdb.conf
    sed -i "s/\(^database = \).*/\1\"${INFLUXDB_DATABASE}\"/" /etc/icinga2/features-enabled/influxdb.conf
    sed -i "s/\(^username = \).*/\1\"${INFLUXDB_USERNAME}\"/" /etc/icinga2/features-enabled/influxdb.conf
    sed -i "s/\(^password = \).*/\1\"${INFLUXDB_PASSWORD}\"/" /etc/icinga2/features-enabled/influxdb.conf
fi


if [ "$ENABLE_API" == "yes" ]; then 
    icinga2 feature enable api 
    if [ !-f "/var/lib/icinga2/ca/ca.key" ]; then
        icinga2 api setup
    fi
fi


if [ "$ENABLE_CHECKER" == "yes" ]; then 
    icinga2 feature enable checker 
fi 

    
if [ "$ENABLE_MAINLOG" == "yes" ]; then 
    icinga2 feature enable mainlog 
fi 

    
if [ "$ENABLE_NOTIFICATION" == "yes" ]; then 
    icinga2 feature enable notification 
fi

    
if [ "$ENABLE_COMMAND" == "yes" ]; then 
    icinga2 feature enable command 
fi 

    
if [ "$ENABLE_COMPATLOG" == "yes" ]; then 
    icinga2 feature enable compatlog 
fi 

    
if [ "$ENABLE_DEBUGLOG" == "yes" ]; then 
    icinga2 feature enable debuglog 
fi 

    
if [ "$ENABLE_GELF" == "yes" ]; then
       icinga2 feature enable gelf 
       sed -i "s/\(^host = \).*/\1\"${GELF_HOST}\"/" /etc/icinga2/features-enabled/gelf.conf
       sed -i "s/\(^port = \).*/\1\"${GELF_PORT}\"/" /etc/icinga2/features-enabled/gelf.conf
fi 

    
if [ "$ENABLE_GRAPHITE" == "yes" ]; then 
    icinga2 feature enable graphite 
    sed -i "s/\(^host = \).*/\1\"${GRAPHITE_HOST}\"/" /etc/icinga2/features-enabled/graphite.conf
    sed -i "s/\(^port = \).*/\1\"${GRAPHITE_PORT}\"/" /etc/icinga2/features-enabled/graphite.conf

fi 

    
if [ "$ENABLE_ICINGASTATUS" == "yes" ]; then 
    icinga2 feature enable icingastatus 
fi 

    
if [ "$ENABLE_IDO-MYSQL" == "yes" ]; then 
    icinga2 feature enable ido-mysql 
    sed -i "s/\(^host = \).*/\1\"${MYSQL_HOST}\"/" /etc/icinga2/features-enabled/ido-mysql.conf
    sed -i "s/\(^port = \).*/\1\"${MYSQL_PORT}\"/" /etc/icinga2/features-enabled/ido-mysql.conf
    sed -i "s/\(^database = \).*/\1\"${MYSQL_DATABASE}\"/" /etc/icinga2/features-enabled/ido-mysql.conf
    sed -i "s/\(^username = \).*/\1\"${MYSQL_USERNAME}\"/" /etc/icinga2/features-enabled/ido-mysql.conf
    sed -i "s/\(^password = \).*/\1\"${MYSQL_PASSWORD}\"/" /etc/icinga2/features-enabled/ido-mysql.conf
    if [ -f /var/mysql-provisioned ]; then
        printf "[client]\n" > /root/.my.cnf
        printf "user=${MYSQL_USERNAME}\n" >> /root/.my.cnf
        printf "password=${MYSQL_PASSWORD}\n" >> /root/.my.cnf
        chmod 600 /root/.my.cnf
	mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} ${MYSQL_DATABASE} < /usr/share/icinga2-ido-mysql/schema/mysql.sql
	if [ ${?} -eq 0 ]; then
            touch /var/mysql-provisioned
	fi
	rm /root/.my.cnf
    fi
fi 

    
if [ "$ENABLE_IDO-PGSQL" == "yes" ]; then 
    icinga2 feature enable ido-pgsql 
    sed -i "s/\(^host = \).*/\1\"${PGSQL_HOST}\"/" /etc/icinga2/features-enabled/ido-pgsql.conf
    sed -i "s/\(^port = \).*/\1\"${PGSQL_PORT}\"/" /etc/icinga2/features-enabled/ido-pgsql.conf
    sed -i "s/\(^database = \).*/\1\"${PGSQL_DATABASE}\"/" /etc/icinga2/features-enabled/ido-pgsql.conf
    sed -i "s/\(^username = \).*/\1\"${PGSQL_USERNAME}\"/" /etc/icinga2/features-enabled/ido-pgsql.conf
    sed -i "s/\(^password = \).*/\1\"${PGSQL_PASSWORD}\"/" /etc/icinga2/features-enabled/ido-pgsql.conf
    if [ -f /var/pgsql-provisioned ]; then
        export PGPASSWORD=${PGSQL_PASSWORD}
	psql -h ${PGSQL_HOST} -p ${PGSQL_PORT} -U ${PGSQL_USERNAME} -d ${PGSQL_DATABASE} < /usr/share/icinga2-ido-pgsql/schema/pgsql.sql
	if [ ${?} -eq 0 ]; then
            touch /var/pgsql-provisioned
	fi
	unset PGPASSWORD
    fi

fi 

    
if [ "$ENABLE_LIVESTATUS" == "yes" ]; then 
    icinga2 feature enable livestatus 
fi 

    
if [ "$ENABLE_OPENTSDB" == "yes" ]; then 
    icinga2 feature enable opentsdb 
    sed -i "s/\(^host = \).*/\1\"${OPENTSDB_HOST}\"/" /etc/icinga2/features-enabled/opentsdb.conf
    sed -i "s/\(^port = \).*/\1\"${OPENTSDB_PORT}\"/" /etc/icinga2/features-enabled/opentsdb.conf
fi 

    
if [ "$ENABLE_PERFDATA" == "yes" ]; then 
    icinga2 feature enable perfdata 
fi 

    
if [ "$ENABLE_STATUSDATA" == "yes" ]; then 
    icinga2 feature enable statusdata 
fi

unset INFLUXDB_PASSWORD
unset MYSQL_PASSWORD
unset PGSQL_PASSWORD

/usr/bin/supervisord -c /supervisord.conf

