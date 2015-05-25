#!/bin/bash

# Slack incoming web-hook URL and user name
WEBHOOK='SLACK_WEBHOOK'
USER='Zabbix'
CHANNEL=${1}
SUBJECT=${2}
# Emoji selection based on Subject
if [ "${SUBJECT}" == 'OK' ]; then
	EMOJI=':white_check_mark:'
elif [ "${SUBJECT}" == 'PROBLEM' ]; then
	EMOJI=':bangbang:'
else
	EMOJI=':slack:'
fi
# Prepare message
MESSAGE="${SUBJECT}: $3"

SLACK_PAYLOAD="payload={\"channel\": \"${CHANNEL}\", \"text\": \"${MESSAGE}\", \"icon_emoji\": \"${EMOJI}\"}"
# Send to slack
curl -m 5 --data-urlencode "${SLACK_PAYLOAD}" ${WEBHOOK}
