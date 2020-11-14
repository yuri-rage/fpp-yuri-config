#!/bin/bash

# *************************************************************
# * force-wifi.sh                                             *
# *                                                           *
# * Intended to connect an RPi with two wifi interfaces       *
# *   (wlan0 and wlan1) to two separate wifi networks without *
# *   breaking Falcon Player.  Run manually or using cron.    *
# *                                                           *
# * Requires iwd and iwctl                                    *
# *                                                           *
# * -- Yuri -- Nov 2020                                       *
# *************************************************************

SSID0="SSID-E.131" # put the E.131 network SSID between the quotes
SSID1="SSID-Home"  # put your home wifi network SSID between the quotes

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

echo
ip addr show | awk '/inet.*wlan/ { sub(/\/24/, ""); print $7, $2 }'

echo -e "\n***** Exiting force-wifi.sh *****\n"
