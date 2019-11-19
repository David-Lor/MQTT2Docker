#!/bin/bash

set -ex

docker build --build-arg SCRIPT=docker2mqtt/docker2mqtt.sh . -t davidlor/docker2mqtt:latest
