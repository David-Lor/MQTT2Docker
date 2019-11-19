# MQTT2Docker

Bash scripts to perform simple Docker container management through MQTT, and send container events to MQTT.

## Scripts

- **mqtt2docker** subscribes to MQTT and performs simple operations (like Start, Stop) on containers
- **docker2mqtt** subscribes to Docker events API and publishes them on MQTT

### mqtt2docker

Publish messages to `mqtt/<containerName>/cmd` to send commands to a container.

Example: START a container named `portainer`: send a message to the topic `mqtt/portainer/cmd` with the payload `start` (payload is not case-sensitive)

#### Commands (payloads) available

- **START**
- **STOP**
- **RESTART**
- **PAUSE**
- **UNPAUSE**
- **KILL**

### docker2mqtt

The script will publish all events occurring on a container to `mqtt/<containerName>/stat`.

Example: when a container named `portainer` starts: a message to the topic `mqtt/portainer/stat` is published with the payload `start`.

### Env variables

Use environment variables as configurations:

- **MQTT_HOST**: host where the MQTT broker is running (if not specified: `localhost`)
- **MQTT_UID** & ARG **DEFAULT_MQTT_UID**: UID of the user that will run the `mosquitto_sub`/`mosquitto_pub` commands (if not specified: `1000` - customizing it is still WIP)

```bash
sudo bash MQTT_HOST=127.0.0.1 mqtt2docker.sh
```

### Premises

- Scripts read or write on the Docker API socket (`/var/run/docker.sock`), so they must run as root
- Scripts are written in pure shell, but require `mosquitto-client` (MQTT client), `jq` (JSON parser) and `curl` (requests to Docker socket) packages
- Calls to `mosquitto_pub` and `mosquitto_sub` are performed by another user different than root
- Both scripts can run on Docker containers mapping the `/var/run/docker.sock` as a bind volume

## Docker images

Docker images are provided to run both mqtt2docker and docker2mqtt.
Both use the same Dockerfile, but result in different images for each service (only difference is the script that runs).

## TODO

- Add Docker tests
- Add Github actions for building, testing & pushing Docker images to DockerHub
- (More) Setting customization - or pass arguments to the script to be part of the `mosquitto_sub`/`mosquitto_pub` args
- Improve UID setting
- Add binary pub/sub endpoints (ON/OFF - like payloads)

## Changelog

- 0.2
  - Add Dockerfile
  - Adapt scripts to pure sh (no bash required)
- 0.1 - Initial release
