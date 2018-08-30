#!/bin/bash

docker build \
  --build-arg user=$(id -un) \
  --build-arg uid=$(id -u) \
  -t dlfs2 .

docker run --rm -ti \
  --runtime nvidia \
  --user=$(id -u) \
  -e DISPLAY \
  -v `pwd`:/app \
  -v /etc/group:/etc/group:ro \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/shadow:/etc/shadow:ro \
  -v /etc/sudoers.d:/etc/sudoers.d:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  dlfs2 \
  bash -l
