#!/bin/bash

MQTT_UID=${MQTT_UID:=1000}
MQTT_HOST=${MQTT_HOST:=localhost}
RUN_AS=$(id -nu $MQTT_UID || awk -v val=$MQTT_UID -F ":" '$3==val{print $1}' /etc/passwd)

function postDocker {
    # params: (container_name, action)
    URL="http://localhost/containers/$2/$1"
    echo "Tx ${URL}"
    curl -XPOST --unix-socket /var/run/docker.sock "${URL}"
}

su $RUN_AS -c "mosquitto_sub -h '${MQTT_HOST}' -t 'mqtt/+/cmd' -v" | while read -r topic payload
do
    container=$(echo "${topic}" | cut -d"/" -f2)
    # TODO case might not be necessary
    case $(echo "${payload}" | tr a-z A-Z) in
        START)
            echo "START $container"
            postDocker start "${container}"
            ;;
        STOP)
            echo "STOP $container"
            postDocker stop "${container}"
            ;;
        RESTART)
            echo "RESTART $container"
            postDocker restart "${container}"
            ;;
        PAUSE)
            echo "PAUSE $container"
            postDocker pause "${container}"
            ;;
        UNPAUSE)
            echo "UNPAUSE $container"
            postDocker unpause "${container}"
            ;;
        KILL)
            echo "KILL $container"
            postDocker kill "${container}"
            ;;
    esac
done
