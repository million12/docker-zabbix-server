FROM million12/nginx-php
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

RUN \
  yum install -y --nogpgcheck nmap traceroute wget sudo net-snmp-devel net-snmp-libs net-snmp net-snmp-perl net-snmp-python net-snmp-utils php-snmp php-ldap java-1.8.0-openjdk java-1.8.0-openjdk-devel mariadb-devel libxml2-devel libcurl-devel OpenIPMI-devel && \
  curl -L -o /tmp/zabbix.tgz http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.4.4/zabbix-2.4.4.tar.gz && \
  mkdir -p /usr/local/src/zabbix && \
  tar zxvf /tmp/zabbix.tgz -C /usr/local/src/zabbix --strip-components=1 && \
  rm -f /tmp/zabbix.tgz && \
  cd /usr/local/src/zabbix && \
  ./configure --enable-server --enable-agent --with-mysql --enable-java --with-net-snmp --with-libcurl --with-libxml2 --with-openipmi && \
  make install && \
  yum clean all && \
  rm -f /tmp/*.*

ENV \
  JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/bin/java \
  JAVA=/usr/lib/jvm/java-1.8.0-openjdk/bin/java \
  DB_ADDRESS=127.0.0.1 DB_USER=admin DB_PASS=password \
  ZABBIX_ADMIN_EMAIL=default@domain.com \
  ZABBIX_SMTP_SERVER=default.smtp.server.com \
  ZABBIX_SMTP_USER=default.smtp.username \
  ZABBIX_SMTP_PASS=default.smtp.password \
  SLACK_WEBHOOK=SLACK_WEBHOOK

COPY container-files /


EXPOSE 10051 10052 80
