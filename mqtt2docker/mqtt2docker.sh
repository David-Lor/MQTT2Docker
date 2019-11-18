#!/bin/bash

MQTT_UID=${MQTT_UID:=1000}
MQTT_HOST=${MQTT_HOST:=localhost}

function postDocker {
    # params: (container_name, action)
    URL="http://localhost/containers/$2/$1"
    echo "Tx ${URL}"
    curl -XPOST --unix-socket /var/run/docker.sock "${URL}"
}

while read topic payload;
do
    container=$(cut -d"/" -f2 <<<"${topic}")
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
done < <(su $(id -nu $MQTT_UID) -c """ mosquitto_sub -h "${MQTT_HOST}" -t "mqtt/+/cmd" -v """)
