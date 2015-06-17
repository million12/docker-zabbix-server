FROM zabbix/zabbix-server-2.4:2.4.5
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

RUN \
    easy_install simplejson

ENV \
  ZABBIX_ADMIN_EMAIL=default@domain.com \
  ZABBIX_SMTP_SERVER=default.smtp.server.com \
  ZABBIX_SMTP_USER=default.smtp.username \
  ZABBIX_SMTP_PASS=default.smtp.password \
  SLACK_WEBHOOK=SLACK_WEBHOOK

COPY container-files /