#!/bin/bash

set -ex

docker build --build-arg SCRIPT=mqtt2docker/mqtt2docker.sh . -t davidlor/mqtt2docker:latest
