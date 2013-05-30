#!/bin/bash

# Ainol Novo 7 Venus Clockworkmod Recovery installation scrip by Nikojiro 
#
# Based on Cloud Deter's CWM kit
# Cf. http://forums.zzkko.com/topic/2651-guide-clockworkmod-cwm-custom-recovery-guide-and-installation/page-10
#
# ClockworkMod Recovery early build developed by bmnguy.
#

########################################################################
# Global definitions - edit if needed
########################################################################

# Path to the adb executable - edit to match your own
ADB_PATH=~/dev/adt-bundle-x86/sdk/platform-tools

# If you don't like the screen being cleared by the script set this to 0
ALLOW_CLEAR=0

SCRIPT_HOME="`pwd`"

# Path to recovery image"
CWM_IMAGE=recovery.img

# Test switch (allows blank runs of the script for testing purposes). 
# Set to 0 to actually execute ADB commands, otherwise they are simply 
# logged.
TEST_MODE=1

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

menu() {
	clearAndDisplayHeader;

	echo "Read all instructions carefully! Refer to readme.txt!"
	echo
	echo "Select from the following options:"
	echo
	echo "1 - Check device connectivity"
	echo "2 - Write CWM recovery image to device"
	echo "Q - Quit"
	echo
	echo "Choose an option :"

	read CHOICE
	case "$CHOICE" in
		1) 
			check;
			;;
		2)
			write;
			;;
		Q)
			finish;
			;;
		q)
			finish;
			;;
		*)
			echo "Choose an option (1-2) or press Q:"
			;;
	esac
	menu;
}

check() {
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Running connection test..."
	echo
	adbCall 'devices'
	echo
	echo
	echo
	echo "Do you see a device listed above? (EG. 20080411   device)"
	echo "If not, the script will not work. Quit now and refer to readme.txt."
	echo "If yes, you're good to go."
	echo
	pause 'Press [Enter] key to move on.';
	menu;
}

write() {
	if [ ! -f $CWM_IMAGE ]; then
		echo "CWM image $CWM_IMAGE not found!"
		echo "Cannot continue!"
		pause 'Press [Enter] key to move on.';
		menu;
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
}

finish() {
	clearAndDisplayHeader;
	echo "To access CWM recovery 'Power off' your Venus."
	echo "Then press and hold the VOLUME MINUS (-) key and the power button key."
	echo
	echo "Huge thanks to bmourit, Cloud Deter and cxz @ ZZKKO forums."
	echo
	echo "Have fun!"
	exit 1
}

########################################################################
# Script execution start
########################################################################

clearAndDisplayHeader;
echo "Script executes in $SCRIPT_HOME"
echo "Script uses adb binary located in $ADB_PATH"
echo	
echo "This script will install an early build of ClockworkMod Recovery "
echo "to your device. It was designed SPECIFICALLY for the Ainol Novo 7"
echo "Venus tablet, but shoudl work on other devices for whch the CWM "
echo "recovery image is deemed compatible (ATM7029 devices: Novo 7 "
echo "Venus, Hero 2, Find, Dream). Do not attempt to use it on any"
echo "other device. I take no responsiblity for any damage or data "
echo "loss caused."
echo
echo "          READ THE README.TXT BEFORE USING THIS SCRIPT"
echo
echo "Have you?"
echo
echo "- Installed adb linux platform tools?"
echo "- Configured udev for your device (may not be mandatory)"
echo "- Enabled USB Debugging?"
echo "- Connected your tablet via USB?"
echo "- Removed any external SD card?"
echo
echo "Yes? Good."
pause 'Press [Enter] key to move on.';
menu;
