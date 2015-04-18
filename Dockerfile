FROM million12/nginx-php
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

#RUN \
#  yum install -y http://repo.zabbix.com/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm && \
#  yum install -y nmap traceroute wget sudo net-snmp-devel net-snmp-libs net-snmp net-snmp-perl net-snmp-python net-snmp-utils php-snmp php-ldap java-1.8.0-openjdk java-1.8.0-openjdk-devel  zabbix-agent zabbix-get zabbix-java-gateway zabbix-sender zabbix-server zabbix-server-mysql zabbix-web zabbix-web-mysql zabbix22-dbfiles-mysql && \
  # Clean yum 
#  yum clean all && rm -rf /tmp/*

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


ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/bin/java JAVA=/usr/lib/jvm/java-1.8.0-openjdk/bin/java DB_ADDRESS=127.0.0.1 DB_USER=admin DB_PASS=password

COPY container-files /

EXPOSE 10051 10052 80
