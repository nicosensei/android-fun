#!/bin/bash


########################################################################
# Global definitions - edit if needed
########################################################################

# Path to the adb executable - edit to match your own
ADB_PATH=~/dev/adt-bundle-x86/sdk/platform-tools

CWM_ZIP="$1"

SCRIPT_HOME="`pwd`"

# Test switch (allows blank runs of the script for testing purposes).
# Set to 0 to actually execute ADB commands, otherwise they are simply
# logged.
TEST_MODE=1

# If you don't like the screen being cleared by the script set this to 0
ALLOW_CLEAR=1

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
	echo "                           CWM flashable ZIP sniper                            "
	echo "                                 by Nikojiro                                   "
    echo "                                    V1.0                                       "
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo
}

########################################################################
# Script execution start
########################################################################

TS="`date +%s`"
TMP_REL_DIR="unzip$TS"
TMP_DIR="$SCRIPT_HOME/$TMP_REL_DIR"
mkdir $TMP_DIR

clearAndDisplayHeader;

echo -e "## Unzipping $CWM_ZIP to temp directory"
unzip $CWM_ZIP -d $TMP_DIR > /dev/null
if [ -d $TMP_DIR/META-INF ]; then rm -rf $TMP_DIR/META-INF; fi
if [ -d $TMP_DIR/meta-inf ]; then rm -rf $TMP_DIR/meta-inf; fi

FILE_LIST="$SCRIPT_HOME/files$TS.list"
find $TMP_REL_DIR * > $FILE_LIST

echo
echo "Script executes in $SCRIPT_HOME"
echo "Script uses adb binary located in $ADB_PATH"
echo "Selected ZIP is $CWM_ZIP"
echo	
echo "This script will unpack the given CWM flashable zip and."
echo "remove every file (not directories) from the device through ADB. "
echo "USE AT YOUR OWN RISK! I recommend making a nandroid backup before "
echo "running this!"
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
echo "Do you see your device listed above?"
echo "If not, the script will not work. Quit now and refer to readme.txt."
echo "If yes, you're good to go."
echo
pause 'Press [Enter] key to move on, otherwise press control+C to abort.';

adbCall "root"
adbCall "wait-for-device"

RM_LIST="$SCRIPT_HOME/deleted_$TS.txt"

while read f; do
  if [ -f $f ]; then
    RELPATH="`echo "$f" | sed 's#'"$TMP_REL_DIR"'##'`"
    echo $RELPATH >> $RM_LIST
	adbCall "shell rm $RELPATH"
  fi
done < $FILE_LIST

# Final words...
clearAndDisplayHeader;
echo "Removed files are listed in $RM_LIST"
echo
echo "Reboot device now? [Y/N]"
read CHOICE
	case "$CHOICE" in
		Y) 
		    echo "Rebooting now..."
			adbCall "reboot";
			;;
		y)
		    echo "Rebooting now..."
			adbCall "reboot";
			;;
		*)  echo "Reboot your device to enable changes."
			;;
	esac
echo
echo "Have fun!"

rm -rf $TMP_DIR
rm -f $FILE_LIST

exit 1
