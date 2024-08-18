#!/bin/sh

docker build --build-arg TASKD_VERSION="1.1.0" -t taskserver .
