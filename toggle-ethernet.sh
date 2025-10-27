#!/bin/bash
ETH="Wired connection 1"
STATUS=$(nmcli -g GENERAL.STATE connection show "$ETH")

if [[ $STATUS == *"activated"* ]]; then
    nmcli connection down "$ETH"
    notify-send "Ethernet" "$ETH is now disconnected"
else
    nmcli connection up "$ETH"
    notify-send "Ethernet" "$ETH is now connected"
fi
