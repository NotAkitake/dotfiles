#!/bin/bash

DEVICE_NAME="YuanCon"
LPEAK_BUTTON_CODE="BTN_BASE5"
RPEAK_BUTTON_CODE="BTN_BASE6"
MODE="hold" # "toggle" or "hold"

# Button states, initializing to 0 to avoid string issues
TOGGLE_STATE_R=0
TOGGLE_STATE_L=0
BUTTON_HELD_R=0
BUTTON_HELD_L=0
BUTTON_PRESSED_R=0
BUTTON_PRESSED_L=0

find_device() {
  local dev
  dev=$(ls /dev/input/by-id/ 2>/dev/null | grep "$DEVICE_NAME" | grep -E "event" | head -n1)
  if [ -n "$dev" ]; then
    echo "/dev/input/by-id/$dev"
  else
    echo ""
  fi
}

handle_button_press() {
  local button_state_var="$1"  # Directly pass variable names
  local toggle_state_var="$2"  # Directly pass variable names
  local focus_direction="$3"

  dms ipc audio micmute

  if [ "$MODE" = "toggle" ]; then
    if [ "${!toggle_state_var}" -eq 0 ]; then
      niri msg action "$focus_direction"
      eval "$toggle_state_var=1"
    else
      niri msg action focus-column-left
      eval "$toggle_state_var=0"
    fi
    sleep 0.2 # debounce
  elif [ "$MODE" = "hold" ] && [ "${!button_state_var}" -eq 0 ]; then
    niri msg action "$focus_direction"
    eval "$button_state_var=1"
  fi
}

handle_button_release() {
  local button_state_var="$1"
  local focus_direction="$2"

  dms ipc audio micmute

  if [ "$MODE" = "hold" ] && [ "${!button_state_var}" -eq 1 ]; then
    niri msg action "$focus_direction"
    eval "$button_state_var=0"
  fi
}

echo "Starting YuanCon listener..."
while true; do
  DEVICE=$(find_device)

  if [ -n "$DEVICE" ]; then
    echo "Device found: $DEVICE"

    evtest "$DEVICE" | while read -r line; do

      # Right peak button press
      if echo "$line" | grep -q "$RPEAK_BUTTON_CODE.*value 1"; then
        if [ "$BUTTON_PRESSED_L" -eq 0 ]; then # prevent left button from being pressed simultaneously
          if [ "$BUTTON_PRESSED_R" -eq 0 ]; then
            BUTTON_PRESSED_R=1
            handle_button_press BUTTON_HELD_R TOGGLE_STATE_R "focus-column-right"
          fi
        fi

      # Left peak button press
      elif echo "$line" | grep -q "$LPEAK_BUTTON_CODE.*value 1"; then
        if [ "$BUTTON_PRESSED_R" -eq 0 ]; then # prevent right button from being pressed simultaneously
          if [ "$BUTTON_PRESSED_L" -eq 0 ]; then
            BUTTON_PRESSED_L=1
            handle_button_press BUTTON_HELD_L TOGGLE_STATE_L "focus-column-left"
          fi
        fi

      # Right peak button release
      elif echo "$line" | grep -q "$RPEAK_BUTTON_CODE.*value 0"; then
        if [ "$BUTTON_PRESSED_R" -eq 1 ]; then
          BUTTON_PRESSED_R=0
          handle_button_release BUTTON_HELD_R "focus-column-left"
        fi

      # Left peak button release
      elif echo "$line" | grep -q "$LPEAK_BUTTON_CODE.*value 0"; then
        if [ "$BUTTON_PRESSED_L" -eq 1 ]; then
          BUTTON_PRESSED_L=0
          handle_button_release BUTTON_HELD_L "focus-column-right"
        fi
      fi

    done

    echo "Device disconnected, waiting for it to be re-plugged..."
    TOGGLE_STATE_R=0
    TOGGLE_STATE_L=0
    BUTTON_HELD_R=0
    BUTTON_HELD_L=0
    BUTTON_PRESSED_R=0
    BUTTON_PRESSED_L=0

  else
    sleep 1
  fi
done

