#!/bin/bash
# Detects if the Microsoft Natural Keyboard has been removed, and if so, changes the keyboard layout to 'U.S'.

keyboard_switcher=/usr/local/bin/keyboardSwitcher
system_profiler SPUSBDataType | grep -q 'Microsoft Natural Keyboard Pro' 2>&1 >/dev/null
if [[ ${PIPESTATUS[1]} != 0  ]]; then
  #echo Keyboard not present!
  current_layout=$($keyboard_switcher get 2>&1)
  if [[ $current_layout == "British - PC" ]]; then 
      $keyboard_switcher select "U.S."
  fi
fi
