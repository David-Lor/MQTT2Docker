#!/bin/bash

MQTT_UID=${MQTT_UID:=1000}
MQTT_HOST=${MQTT_HOST:=localhost}
RUN_AS=$(id -nu $MQTT_UID || awk -v val=$MQTT_UID -F ":" '$3==val{print $1}' /etc/passwd)

curl -s --no-buffer --unix-socket /var/run/docker.sock http://localhost/events | while read -r line
do
    type=$(echo "${line}" | jq -r ".Type")
    if [ "$type" == "container" ]
    then
        status=$(echo "${line}" | jq -r ".status")
        container_name=$(echo "${line}" | jq -r ".Actor.Attributes.name")
        su $RUN_AS -c "mosquitto_pub -h '${MQTT_HOST}' -t 'mqtt/${container_name}/stat' -m '${status}'"
    fi
done
