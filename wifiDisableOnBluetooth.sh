#!/bin/bash

sudo apt-get install -y inotify-tools
while true
do
  RES=`inotifywait -q -e CREATE,DELETE /dev/input/`
  case "$RES" in
    "/dev/input/ DELETE event1")
    ifconfig wlan0 up
    ;;
    "/dev/input/ CREATE event1")
    ifconfig wlan0 down
    ;;
  esac
  # Allow ctrl c out
  test $? -gt 128 && break;
done &
