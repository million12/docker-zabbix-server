#!/bin/sh
export MAIL_FROM=default@domain.com
export MAIL_TO=$1
export MAIL_SUBJECT=$2
export MAIL_BODY=$3
export MAIL_SMTP_SERVER=default.smtp.server.com
export MAIL_SMTP_USER=default.smtp.username
export MAIL_SMTP_PASS=default.smtp.password
/usr/bin/sendmail -f ${MAIL_FROM} -t ${MAIL_TO} -u ${MAIL_SUBJECT} -m ${MAIL_BODY} -s ${MAIL_SMTP_SERVER} -xu ${MAIL_SMTP_USER} -xp ${MAIL_SMTP_PASS} -o tls=no