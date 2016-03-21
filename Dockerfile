FROM zabbix/zabbix-3.0:3.0.1
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

RUN \
  rpm --rebuilddb && yum clean all && \
  yum install --nogpgcheck -y gcc make && \
  easy_install simplejson && \
  rpm -e --nodeps make gcc


ENV \
  ZABBIX_ADMIN_EMAIL=default@domain.com \
  ZABBIX_SMTP_SERVER=default.smtp.server.com \
  ZABBIX_SMTP_USER=default.smtp.username \
  ZABBIX_SMTP_PASS=default.smtp.password \
  SLACK_WEBHOOK=SLACK_WEBHOOK

COPY container-files /
RUN mv /usr/local/etc/web/zabbix.conf.php /usr/local/src/zabbix/frontends/php/conf/zabbix.conf.php
