#!/bin/bash


# Check for required packages
function package_exists() {
    return dpkg -l "$1" &> /dev/null
}

if ! package_exists inotify-tools ; then
    sudo apt-get install -y inotify-tools
fi

# Loop through to search for bluetooth connect/disconnect
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
