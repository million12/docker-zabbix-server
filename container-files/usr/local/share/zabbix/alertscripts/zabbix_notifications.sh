#!/bin/bash

curl -X POST\
 -H "Content-type:application/json"\
 -d "{Id:'$1', text:'$2', triggerId:'$3', playSound:true}"\
 http://zabbkit.inside.cactussoft.biz/api/messages