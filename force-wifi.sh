#!/bin/bash

SSID0="E.131-SSID" # put the E.131 network SSID between the quotes
SSID1="Home-SSID"      # put your home wifi network SSID between the quotes

function connect_wlan0 {
  echo "Attempting to connect wlan0 to SSID $SSID0"
  while ! iwctl station wlan0 get-networks | grep "$SSID0 " > /dev/null; do
    iwctl station wlan0 scan
    ((c++)) && ((c==5)) && c=0 && break
    sleep 2
  done
  if iwctl station wlan0 get-networks | grep "$SSID0 " > /dev/null; then
    iwctl station wlan0 connect $SSID0
    echo "wlan0 connected to SSID $SSID0"
  else
    echo "Cannot connect wlan0 to SSID $SSID0"
  fi
}

function connect_wlan1 {
 echo "Attempting to connect wlan1 to SSID $SSID1"
 while ! iwctl station wlan1 get-networks | grep "$SSID1 " > /dev/null; do
    iwctl station wlan1 scan
    ((c++)) && ((c==5)) && c=0 && break
    sleep 2
  done
  if iwctl station wlan1 get-networks | grep "$SSID1 " > /dev/null; then
    iwctl station wlan1 connect $SSID1
    echo "wlan1 connected to SSID $SSID1"
  else
    echo  "Cannot connect wlan1 to SSID $SSID1"
  fi
}

echo -e "\n***** Starting force-wifi.sh *****\n"
echo "Searching for wlan0 and wlan1..."

while  ! ( iwctl station list | grep wlan0 > /dev/null && iwctl station list | grep wlan1 > /dev/null ); do
  echo "Waiting for wlan0 and wlan1..."
  sleep 1
done
echo "Stations wlan0 and wlan1 found"

if iwctl station wlan0 get-networks | grep '>' | grep "$SSID0 " > /dev/null; then
  echo "wlan0 connected to SSID $SSID0"
else
  iwctl station wlan0 disconnect
  connect_wlan0
fi

if iwctl station wlan1 get-networks | grep '>' | grep "$SSID1 " > /dev/null; then
 echo "wlan1 connected to SSID $SSID1"
else
  iwctl station wlan1 disconnect
  connect_wlan1
fi

echo -e "\n***** Exiting force-wifi.sh *****\n"