#!/bin/bash

#echo "$MACHINE_ID" > /etc/machine-id
echo "92bb261f13154fd3b4592a2429f75897" > /etc/machine-id
echo "$CONTROLLER_URL" > /etc/twingate/controller_url.conf
echo "$ACCOUNT" > /etc/twingate/network.conf

TOKEN=$(printf '%s\n' "$TG_TOKEN" | sed -e 's/[\/&]/\\&/g')
sed -i "s/_TOKEN_/$TOKEN/" /etc/twingate/config.json
twingated /etc/twingate/config.json > /var/log/twingated.log 2>&1 &
