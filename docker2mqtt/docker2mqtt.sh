#!/bin/bash

MQTT_UID=${MQTT_UID:=1000}
MQTT_HOST=${MQTT_HOST:=localhost}

while read -r line;
do
    type=$(echo "${line}" | jq -r ".Type")
    if [ "$type" == "container" ]
    then
        status=$(echo "${line}" | jq -r ".status")
        container_name=$(echo "${line}" | jq -r ".Actor.Attributes.name")
        su $(id -nu $MQTT_UID) -c """ mosquitto_pub -h "${MQTT_HOST}" -t "mqtt/${container_name}/stat" -m "${status}" """
    fi
done < <(curl -s --no-buffer --unix-socket /var/run/docker.sock http://localhost/events)
