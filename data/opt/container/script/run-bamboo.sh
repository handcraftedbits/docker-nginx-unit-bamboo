#!/bin/bash

. /opt/container/script/unit-utils.sh

# Check required environment variables and fix the NGINX unit configuration.

checkCommonRequiredVariables

copyUnitConf nginx-unit-bamboo > /dev/null

logUrlPrefix "bamboo"

notifyUnitStarted

# Fix Bamboo configuration.

bamboo_config=/opt/bamboo/conf/server.xml

cp /opt/container/template/server.xml.template ${bamboo_config}

fileSubstitute ${bamboo_config} NGINX_UNIT_HOSTS ${NGINX_UNIT_HOSTS}
fileSubstitute ${bamboo_config} NGINX_URL_PREFIX `normalizeSlashesSingleSlashToEmpty ${NGINX_URL_PREFIX}`

# Import certificate (so we can integrate with other Atlassian product instances).

printf "changeit\nyes" | keytool -import -trustcacerts -alias root \
     -file /etc/letsencrypt/live/${NGINX_UNIT_HOSTS}/fullchain.pem -keystore \
     /usr/lib/jvm/default-jvm/jre/lib/security/cacerts

# Start Bamboo.

exec /opt/bamboo/bin/start-bamboo.sh -fg
