#!/bin/bash

# Ainol Novo 7 Venus Clockworkmod Recovery installation scrip by Nikojiro
#
# Based on Cloud Deter's CWM kit
# Cf. http://forums.zzkko.com/topic/2651-guide-clockworkmod-cwm-custom-recovery-guide-and-installation/page-10
#
# ClockworkMod Recovery early build developed by bmnguy.
# Cf. http://www.slatedroid.com/topic/71985-cwm-recovery-for-hero-ii/
#

########################################################################
# Global definitions - edit if needed
########################################################################

# Path to the adb executable - edit to match your own
ADB_PATH=~/dev/adt-bundle-x86/sdk/platform-tools

# If you don't like the screen being cleared by the script set this to 0
ALLOW_CLEAR=1

SCRIPT_HOME="`pwd`"

# Path to recovery image"
CWM_IMAGE=./image/recovery_bnmguy.img
CMW_IMAGE="`cd "$CWM_IMAGE";pwd`/`basename $CWM_IMAGE`"

# Test switch (allows blank runs of the script for testing purposes).
# Set to 0 to actually execute ADB commands, otherwise they are simply
# logged.
TEST_MODE=0

########################################################################
# Function definitions
########################################################################

pause() {
   read -p "$*"
}

adbCall() {
	COMMAND="$ADB_PATH/adb $1"
	if [ "$TEST_MODE" -eq "0" ]; 
		then $COMMAND
	else
		echo -e "[test mode] $COMMAND"
	fi 
}

clearAndDisplayHeader() {
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "                    Ainol Novo 7 Venus CWM Recovery install kit                "
	echo "                                 by Nikojiro                                   "
    echo "                                    V1.0                                       "
	echo "                    Based on Cloud Deter's CWM kit @ ZZKKO forums              "
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo
}

########################################################################
# Script execution start
########################################################################

clearAndDisplayHeader;
echo "Script executes in $SCRIPT_HOME"
echo "Script uses adb binary located in $ADB_PATH"
echo "Selected recovery image is $CWM_IMAGE"
echo	
echo "This script will install an early build of ClockworkMod Recovery "
echo "to your device. While the recovery image is compatible with various"
echo "ATM7029 devices (Novo 7 Venus, Hero 2, Find, Dream), this script"
echo "has only been tested on the Ainol Novo 7 Venus tablet."
echo "I take no responsiblity for any damage or data loss caused."
echo
echo "          READ THE README.TXT BEFORE USING THIS SCRIPT"
echo
echo "Have you?"
echo
echo "- Installed adb linux platform tools?"
echo "- Configured udev for your device (cf. readme.txt)"
echo "- Configured adb for your device (cf. readme.txt)"
echo "- Enabled USB Debugging on your tablet?"
echo "- Connected your tablet via USB?"
echo "- Removed any external SD card?"
echo
echo "Yes? Good."
pause 'Press [Enter] key to move on.';

# Run a connection test first
clearAndDisplayHeader;
echo "Running connection test..."
echo
adbCall 'devices'
echo
echo
echo
echo "Do you see a device listed above? (e.g. 0123456789ABCDEF  device)"
echo "If not, the script will not work. Quit now and refer to readme.txt."
echo "If yes, you're good to go."
echo
pause 'Press [Enter] key to move on, otherwise press control+C to abort.';

# Now on to the real thing!
clearAndDisplayHeader;

if [ ! -f $CWM_IMAGE ]; then
    echo "CWM image $CWM_IMAGE not found!"
    echo "Cannot continue!"
    pause 'Press [Enter] key to move on.';
    exit 0;
fi
echo "Venus CWM recovery install script by Cloud Deter."
echo "Script based off cxz's commands."
echo "Recovery by bnmguy."
echo "Please wait while ADB starts and gains root..."
adbCall "root"
adbCall "wait-for-device"
echo "Making recovery directory..."
adbCall "shell busybox mkdir /mnt/obb/rec"
echo "Mounting recovery partition..."
adbCall "shell busybox mount -t vfat /dev/block/acta /mnt/obb/rec"
echo "Copying CWM to the recovery partition..."
adbCall "push $CWM_IMAGE /mnt/obb/rec"
echo "Stopping ADB..."
adbCall "kill-server"
echo "Finished!"
pause 'Press [Enter] key to move on.';

# Final words...
clearAndDisplayHeader;
echo "To access CWM recovery 'Power off' your Venus."
echo "Then press and hold the VOLUME MINUS (-) key and the power button key."
echo
echo "Huge thanks to bmourit, Cloud Deter and cxz @ ZZKKO forums."
echo
echo "Have fun!"
exit 1

