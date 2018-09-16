#!/bin/bash

#######################################################
## Simple bash script to change OSX network location ##
## based on the wifi network you're connected too.   ##
## Author: Rob Sonke                                 ##
## This is executed periodically with LaunchControl  ##
#######################################################

# Constants defining the situation
HOME_WIFI='SONKEBERKS'
WORK_WIFI='MXTHQ'
PUNE_WIFI='MAXXTON'
HOME_LOCATION='Home'
WORK_LOCATION='Office'
PUNE_LOCATION='Pune'
EXT_LOCATION='External'
WIFI_DEV='en0'

# Gather information
WIFI_NAME="$(networksetup -getairportnetwork $WIFI_DEV | sed s/'Current Wi-Fi Network: '//g)"
CURRENT_LOCATION="$(networksetup -getcurrentlocation)"
WIFI_STRING="$(networksetup -getairportnetwork $WIFI_DEV)"

echo 'Current wifi: '$WIFI_NAME

# to uppercase
WIFI_NAME=$(echo "$WIFI_NAME" | tr '[:lower:]'  '[:upper:]')

# Check if we are on a wifi network
if [[ $WIFI_STRING == 'Current Wi'* ]]
then
  # Check and change location
  if [[ "$WIFI_NAME" == $HOME_WIFI* ]]
  then
    if [ $CURRENT_LOCATION != $HOME_LOCATION ]
    then
      sudo networksetup -switchtolocation $HOME_LOCATION
      osascript -e 'display notification "Home sweet home!" with title "Switched to location Home"'
      exit
    fi
  elif [[ "$WIFI_NAME" == $WORK_WIFI* ]]
  then
    if [ $CURRENT_LOCATION != $WORK_LOCATION ]
    then
      # we're at work, check if location is work too
      sudo networksetup -switchtolocation $WORK_LOCATION
      osascript -e 'display notification "Rise and shine, a new working day has started." with title "Switched to location Office"'
      exit
    fi
  elif [[ ${WIFI_NAME} == ${PUNE_WIFI}* ]]
  then
    if [ $CURRENT_LOCATION != $PUNE_LOCATION ]
    then
      # we're at work in the Pune office, check if location is Pune too
      sudo networksetup -switchtolocation $PUNE_LOCATION
      osascript -e 'display notification "Rise and shine, a new working day has started in Pune." with title "Switched to location Pune Office"'
      exit
    fi
  else
    if [ $CURRENT_LOCATION != $EXT_LOCATION ]
    then
      # move to external profile, you went to a scary new location
      sudo networksetup -switchtolocation $EXT_LOCATION
      osascript -e 'display notification "Move to external profile, you went to a scary new location" with title "Switched to location External"'
      exit
    fi
  fi
fi