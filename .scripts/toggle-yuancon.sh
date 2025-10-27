#!/bin/bash
set -euo pipefail

# Configuration
readonly DEVICE_NAME="YuanCon"
readonly LPEAK_BUTTON_CODE="BTN_BASE5"
readonly RPEAK_BUTTON_CODE="BTN_BASE6"
readonly MODE="hold" # "toggle" or "hold"

# State variables
toggle_r=0
toggle_l=0
held_r=0
held_l=0
pressed_r=0
pressed_l=0

find_device() {
  local dev
  dev=$(find /dev/input/by-id/ -name "*${DEVICE_NAME}*event*" -print -quit 2>/dev/null)
  echo "$dev"
}

toggle_mic() {
  dms ipc audio micmute
}

handle_button_press() {
  local button="$1"
  local focus_dir="$2"
  local opposite_dir="$3"
  local toggle_var="toggle_${button}"
  local held_var="held_${button}"

  toggle_mic

  if [ "$MODE" = "toggle" ]; then
    if [ "${!toggle_var}" -eq 0 ]; then
      niri msg action "$focus_dir"
      eval "${toggle_var}=1"
    else
      niri msg action "$opposite_dir"
      eval "${toggle_var}=0"
    fi
    sleep 0.2
  elif [ "$MODE" = "hold" ] && [ "${!held_var}" -eq 0 ]; then
    niri msg action "$focus_dir"
    eval "${held_var}=1"
  fi
}

handle_button_release() {
  local button="$1"
  local focus_dir="$2"
  local held_var="held_${button}"

  toggle_mic

  if [ "$MODE" = "hold" ] && [ "${!held_var}" -eq 1 ]; then
    niri msg action "$focus_dir"
    eval "${held_var}=0"
  fi
}

reset_state() {
  toggle_r=0
  toggle_l=0
  held_r=0
  held_l=0
  pressed_r=0
  pressed_l=0
}

process_event() {
  local line="$1"

  # Right button press
  if echo "$line" | grep -q "${RPEAK_BUTTON_CODE}.*value 1"; then
    if [ "$pressed_l" -eq 0 ] && [ "$pressed_r" -eq 0 ]; then
      pressed_r=1
      handle_button_press "r" "focus-column-right" "focus-column-left"
    fi

  # Left button press
  elif echo "$line" | grep -q "${LPEAK_BUTTON_CODE}.*value 1"; then
    if [ "$pressed_r" -eq 0 ] && [ "$pressed_l" -eq 0 ]; then
      pressed_l=1
      handle_button_press "l" "focus-column-left" "focus-column-right"
    fi

  # Right button release
  elif echo "$line" | grep -q "${RPEAK_BUTTON_CODE}.*value 0"; then
    if [ "$pressed_r" -eq 1 ]; then
      pressed_r=0
      handle_button_release "r" "focus-column-left"
    fi

  # Left button release
  elif echo "$line" | grep -q "${LPEAK_BUTTON_CODE}.*value 0"; then
    if [ "$pressed_l" -eq 1 ]; then
      pressed_l=0
      handle_button_release "l" "focus-column-right"
    fi
  fi
}

main() {
  echo "Starting YuanCon listener..."

  while true; do
    local device
    device=$(find_device)

    if [ -n "$device" ]; then
      echo "Device found: $device"

      evtest "$device" 2>/dev/null | while IFS= read -r line; do
        process_event "$line"
      done || true

      echo "Device disconnected, waiting for reconnection..."
      reset_state
    else
      sleep 1
    fi
  done
}

main
