#!/bin/sh
set -eu
export TERM=xterm
# Bash Colors
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`
# Logging Functions
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
email_setup() {
  sed -i 's/default@domain.com/'${ZABBIX_ADMIN_EMAIL}'/g' /usr/local/share/zabbix/alertscripts/zabbix_sendmail.sh
  sed -i 's/default.smtp.server.com/'${ZABBIX_SMTP_SERVER}'/g' /usr/local/share/zabbix/alertscripts/zabbix_sendmail.sh
  sed -i 's/default.smtp.username/'${ZABBIX_SMTP_USER}'/g' /usr/local/share/zabbix/alertscripts/zabbix_sendmail.sh
  sed -i 's/default.smtp.password/'${ZABBIX_SMTP_PASS}'/g' /usr/local/share/zabbix/alertscripts/zabbix_sendmail.sh
}
slack_webhook() {
  sed -i 's#SLACK_WEBHOOK#'$SLACK_WEBHOOK'#g' /usr/local/share/zabbix/alertscripts/zabbix_slack.sh
}
####################### End of default settings #######################
# Zabbix default sql files
log "Editing Admin Email Server Settings"
email_setup
log "Email server settings updated."
log "Adding Slack integration and webhook provided by the user"
slack_webhook
log "Slack configuration updated"
#zabbix_agentd -c /usr/local/etc/zabbix_agentd.conf
