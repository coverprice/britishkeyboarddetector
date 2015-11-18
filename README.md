## Description

I use a British PC keyboard at work (plugged into my monitor) and the Mac laptop has a U.S. keyboard.
I want the Mac to automatically select the British KB layout when it's plugged in, and
switch back to the US layout when it's detached.

## Install

1. Use homebrew to install keyboardSwitcher:

`
$ brew tap lutzifer/homebrew-tap
$ brew install keyboardSwitcher
`

Homepage is here: https://github.com/Lutzifer/keyboardSwitcher

2. Add the *.plist files into ~/Library/LaunchAgents, and make sure the paths are correct to find
the BKD executable and the detect_removal.sh.

3. Load the *.plist files with:

`
launchctl load ~/Library/LaunchAgents/com.jrussell.keyboard.plist
launchctl load ~/Library/LaunchAgents/com.jrussell.keyboard-detach.plist
`

## How it works

The main plist file will launch the utility 'BKD' which simply consumes the USB attach event (necessary,
otherwise launchd will re-launch BKD every 10 seconds), and then calls
`/usr/local/bin/keyboardSwitcher select "British - PC"` to switch the keyboard layout.

For some obtuse reason, the corresponding "detach" event is not immediately fired when the keyboard
is unplugged, which means we can't use the same mechanism to revert the keyboard layout back to U.S, so
instead we have a cronjob (also launched by launchd) which lists the USB devices and searches for
the keyboard, and if it can't find it then it sets the layout back to US.

This means that the insertion of the British keyboard will result in an instant switch, but removing
it may not switch back to the U.S. layout for up to 30 seconds.

## Notes

The USB ID/Vendor numbers in the keyboard detector were derived from the output of `system_profiler SPUSBDataType`.
