#!/bin/bash

# DROID X360 SUPERSCRIPT by TEHCRUCIBLE - V0.5
# Bash shell port by Nikojiro.

########################################################################
# Global definitions - edit if needed
########################################################################

# Path to the adb executable - edit to match your own
ADB_PATH=~/dev/adt-bundle-x86/sdk/platform-tools

# If you don't like the screen being cleared by the script set this to 0
ALLOW_CLEAR=0

SCRIPT_HOME="`pwd`"

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
	echo "                             DROID X360 SUPERSCRIPT                            "
	echo "                                 BY TEHCRUCIBLE                                "
	echo "                               V0.5 - FOR ICS 4.04                             "
	echo "                           Bash shell port by Nikojiro                         "
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo
}

menu() {
	clearAndDisplayHeader;
	
	echo "Read all instructions carefully! Refer to the README.TXT if you are unsure."
	echo
	echo "Select from the following options:"
	echo
	echo "1 - Check device connectivity"
	echo "2 - Backup core system files"
	echo "3 - SuperScript Express"
	echo "4 - Patch keypad controls"
	echo "5 - Increase system UI size (INSTALLS APEX LAUNCHER)"
	echo "6 - Upgrade from v0.4"
	echo "Q - Quit"
	echo
	echo "Choose an option (1-5):"

	read CHOICE
	case "$CHOICE" in
		1) 
			check;
			;;
		2)
			backup;
			;;
		3)
			express;
			;;
		4)
			patch;
			;;
		5)
			launcher;
			;;
		6)
			upgrade;
			;;
		Q)
			finish;
			;;
		q)
			finish;
			;;
		*)
			echo "Choose an option (1-5) or press Q:"
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
	echo "If not, the script will not work. Quit now and refer to README.TXT."
	echo "If yes, your good to go."
	echo
	pause 'Press [Enter] key to move on.';
	menu;
}

backup() {
	adbCall "root"
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Backing up files..."
	adbCall "pull /system/media/bootanimation.zip backup/bootanimation.zip"
	adbCall "pull /system/app/SystemUI.apk backup/SystemUI.apk"
	adbCall "pull /system/framework/framework-res.apk backup/framework-res.apk"
	adbCall "pull /system/build.prop backup/build.prop"
	adbCall "pull /default.prop backup/default.prop"
	adbCall "pull /init.rc backup/init.rc"
	adbCall "pull /init backup/init"
	adbCall "pull /system/usr/keylayout backup/keylayout"
	adbCall "pull /system/bin/preinstall.sh backup/preinstall.sh"
	adbCall "pull /initlogo.rle backup/initlogo.rle"
	adbCall "pull /system/app/Browser.apk backup/Browser.apk"
	adbCall "pull /system/vendor/modules/sun4i-keypad.ko backup/sun4i-keypad.ko"
	adbCall "pull /system/usr/keylayout/Generic.kl backup/Generic.kl"
	adbCall "pull /system/framework/android.policy.jar backup/android.policy.jar"
	adbCall "pull /system/app/Settings.apk backup/Settings.apk"
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Files have been backed up. You can find them in the 'backup' folder"
	echo "should you ever need them. Press any key to return to the menu and"
	echo "move on to Step 3."
	echo
	pause 'Press [Enter] key to move on.';
	menu;
}

express() {
	clearAndDisplayHeader;
	
	echo "Permanent changes begin now. Are you sure you read README.TXT?"
	echo
	echo "We are going to disable some unnecessary Android services and components,"
	echo "remove pre-installed bloatware, and update some core system framework files."
	echo "We will also patch the Google Play store and apply various system tweaks to"
	echo "increase performance. Some errors throughout this process are not uncommon."
	echo
	echo "Your device will reboot at the completion of this step."
	echo
	echo "Ready? Cool, here we go."
	pause 'Press [Enter] key to move on.';
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Logging in as ROOT User"
	adbCall "root"
	adbCall "remount"
	echo "Removing pre-installed Chinese crap..."
	echo
	adbCall "shell rm /system/app/PPTV_aPad_1.2.2.apk"
	adbCall "shell rm /system/app/UCBrowser_V1.0.1.146.apk"
	adbCall "shell rm /system/app/com.hiapk.marketpho-2.apk"
	adbCall "shell rm /system/app/PinyinIME.apk"
	adbCall "shell rm /system/app/OpenWnn.apk"
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Done. Moving on..."
	echo
	echo "Installing modified build.prop and market..."
	echo
	adbCall "push sausage/preinstall.sh /system/bin/preinstall.sh"
	adbCall "push sausage/build.prop /system/build.prop"
	echo
	echo "Upgrading Market..."
	echo
	adbCall "shell rm /system/app/vending.apk"
	adbCall "shell rm /system/app/Vending.apk"
	echo "YOU SHOULD HAVE GOTTEN AT LEAST 1 ERROR"
	adbCall "push sausage/vending/*.apk /system/app/vending.apk"
	echo
	for N in sausage/permissions/*.xml; do adbCall "push $N /system/etc/permissions/`basename $N`"; done
	for N in /system/etc/permissions/*.xml; do adbCall "shell chmod 644 /system/etc/permissions/`basename $N`"; done
	echo
	echo "Removing some other files. Some errors are not uncommon."
	echo
	adbCall "shell rm /system/media/bootanimation.zip"
	adbCall "push sausage/boot/bootanimation.zip /system/media/bootanimation.zip"
	echo
	echo "Now to modify the (system/app and preinstall) directories..."
	echo
	for N in sausage/apps/*.apk; do adbCall "push $N /system/app/`basename $N`"; done
	for N in sausage/*.apk; do adbCall "push $N /system/preinstall/`basename $N`"; done
	echo
	echo "Some permissions files..."
	echo
	for N in sausage/permissions/*.xml; do adbCall "push $N /system/etc/permissions/`basename $N`"; done
	for N in /system/etc/permissions/*.xml; do adbCall "shell chmod 644 /system/etc/permissions/`basename $N`"; done
	echo
	echo "Fixing issues with Gallery sync, removing 2160P Video and installing"
	echo "default Google Gallery application..."
	echo
	adbCall "shell rm /system/app/Gallery2.apk"
	adbCall "shell rm /data/app/Gallery2.apk"
	adbCall "shell rm /data/app/com.android.gallery3d*.apk"
	adbCall "shell rm /data/app/com.android.gallery3d-1.apk"
	echo
	echo "Updating files..."
	echo
	adbCall "push sausage/fixes/GalleryGoogle.apk /system/app/GalleryGoogle.apk"
	adbCall "shell chmod 644 /system/app/GalleryGoogle.apk"
	echo
	echo "Applying smart status bar script..."
	echo
	adbCall "shell rm /system/framework/android.policy.jar"
	adbCall "push status/android.policy.jar /system/framework/android.policy.jar"
	adbCall "shell chmod 644 /system/framework/android.policy.jar"
	adbCall "shell chown 0.0 /system/framework/android.policy.jar"
	adbCall "shell rm /system/app/Settings.apk"
	adbCall "push status/Settings.apk /system/app/Settings.apk"
	adbCall "shell chmod 644 /system/app/Settings.apk"
	adbCall "shell chown 0.0 /system/app/Settings.apk"
	adbCall "reboot"
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Finished updating files. We're done! Your device is now rebooting."
	echo 
	echo "After the reboot, you're good to go.  However, I highly recommend"
	echo "you run Step 4 to install Furan's keypad patch to fix controller"
	echo "issues.  You may also want to try out the new increased system UI "
	echo "size option (Step 5)."
	echo
	echo "Also, if your status bar is missing after the reboot, you need to"
	echo "enable \"Smart screen mode\" to restore it. On the device:"
	echo
	echo "Settings - Display - Screen mode - Smart screen mode"
	echo
	pause 'Press [Enter] key to move on.';
	menu;
}

patch() {
	adbCall "root"
	adbCall "remount"
	
	clearAndDisplayHeader;
	
	echo "Version 0.4 of the SuperScript corrected button mapping for Android, matching"
	echo "the default linux gamepad keycodes. Step 1 will set your D-Pad and ABXY button "
	echo "controls correctly and will also map the hardware buttons on your X360 to:"
	echo
	echo "BACK - Button under left thumbstick"
	echo "MENU - Select button"
	echo "HOME - Start button"
	echo
	echo "How would you like to patch?"
	echo
	echo "1 - Install Furan's keypad patch and remap buttons"
	echo "2 - Install Furan's keypad patch but dont remap buttons"
	echo "3 - Revert to original keypad config (MUST HAVE RUN STEP 1 BACKUP FIRST)"
	echo "Q - Go Back"
	echo
	echo "Choose a step (1-3):"
	
	read CHOICE
	case "$CHOICE" in
		1) 
			patch1;
			;;
		2)
			patch2;
			;;
		3)
			patch3;
			;;
		Q)
			menu;
			;;
		q)
			menu;
			;;
		*)
			echo "Choose a step (1-3) or press Q:"
			;;
	esac
	patch;
}
			
patch1() {
	echo
	echo "Patching..."
	echo
	adbCall "push keypad/sun4i-keypad.ko /system/vendor/modules/sun4i-keypad.ko"
	adbCall "shell chmod 644 /system/vendor/modules/sun4i-keypad.ko"
	adbCall "push keypad/Generic.kl /system/usr/keylayout/Generic.kl"
	adbCall "shell chmod 644 /system/usr/keylayout/Generic.kl"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

patch2() {
	echo
	echo "Patching..."
	echo
	adbCall "push keypad/sun4i-keypad.ko /system/vendor/modules/sun4i-keypad.ko"
	adbCall "shell chmod 644 /system/vendor/modules/sun4i-keypad.ko"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

patch3() {
	echo
	echo "Patching..."
	echo
	adbCall "push backup/sun4i-keypad.ko /system/vendor/modules/sun4i-keypad.ko"
	adbCall "shell chmod 644 /system/vendor/modules/sun4i-keypad.ko"
	adbCall "push backup/home/Generic.kl /system/usr/keylayout/Generic.kl"
	adbCall "shell chmod 644 /system/usr/keylayout/Generic.kl"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

launcher() {
	clearAndDisplayHeader;
	
	echo "This step will slightly increase the system UI size of your Droid X360, making"
	echo "things easier to read and use. Unfortunatly this patch is incompatible with"
	echo "the default ICS Launcher app so we will replace it with the more powerful "
	echo "Apex Launcher."
	echo
	echo "NOTE: This is an experimental feature. Use with caution.  You can return to"
	echo "this menu to revert changes if necessary. Your Droid X360 will reboot after"
	echo "this step."
	echo
	echo "I have also included a Apex Launcher settings file for best performance and"
	echo "compatiblility.  If you would like to use my recommended settings, after the"
	echo "reboot, on the device go to:"
	echo
	echo "Apex Settings - Backup and Restore - Restore Apex Settings."
	echo
	pause 'Press [Enter] key to move on.';
	launchermenu;
}

launchermenu() {
	clearAndDisplayHeader;
	
	echo "Select from the following:"
	echo
	echo "1 - Increase system UI size"
	echo "2 - Restore default UI size"
	echo "3 - Back to main menu"
	echo
	echo "Choose a step (1-3):"
	
	read CHOICE
	case "$CHOICE" in
		1) 
			launcher1;
			;;
		2)
			launcher2;
			;;
		3)
			menu;
			;;
		*)
			echo "Choose a step (1-3):"
			;;
	esac
	launchermenu;
}

launcher1() {
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Replacing Launcher..."
	echo
	adbCall "shell rm /system/app/Launcher.apk"
	adbCall "shell rm /system/app/launcher.apk"
	adbCall "shell rm /system/app/Launcher2.apk"
	echo "YOU SHOULD HAVE GOTTEN AT LEAST 1 ERROR"
	adbCall "push launcher/*.apk /system/app/Launcher.apk"
	echo
	echo "Copy apex launcher settings..."
	echo
	adbCall "push launcher/apex_settings.bak /mnt/sdcard/Android/data/apexlauncher/apex_settings.bak"
	echo
	echo "Increasing UI size via modified build.prop..."
	echo
	adbCall "push launcher/build.prop /system/build.prop"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

launcher2() {
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Would you like keep Apex Launcher?"
	echo
	echo "Choose Y or N:"
	
	read CHOICE
	case "$CHOICE" in
		Y) 
			launcher3;
			;;
		y)
			launcher3;
			;;
		N)
			launcher4;
			;;
		n)
			launcher4;
			;;
		*)
			echo "Choose Y or N:"
			;;
	esac
	launcher2;
}

launcher3() {
	echo
	echo "Reverting UI size..."
	echo
	adbCall "push sausage/build.prop /system/build.prop"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

launcher4() {
	echo
	echo "Reverting UI size..."
	echo
	adbCall "push sausage/build.prop /system/build.prop"
	echo
	echo "Restoring stock ICS launcher..."
	echo
	adbCall "shell rm /system/app/Launcher.apk"
	adbCall "shell rm /system/app/launcher.apk"
	adbCall "shell rm /system/app/Launcher2.apk"
	echo "YOU SHOULD HAVE GOTTEN AT LEAST 1 ERROR"
	adbCall "push launcher/stock/*.apk /system/app/Launcher.apk"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

upgrade() {
	clearAndDisplayHeader;
	
	echo "Whats new in v0.5?"
	echo
	echo "- Install status bar patch to allow apps to run in true fullscreen."
	echo
	echo
	echo "SuperScript v0.5 introduces a patch to the status bar that allows apps and"
	echo "emulators to run in fullscreen mode, temporarily removing the status bar and"
	echo "virtual buttons.  As such, I strongly recommend that you also run Step 4 to"
	echo "remap your Droids hardware buttons so that you can still close fullscreen apps."
	echo
	echo "After patching, your device will reboot.  Also, you will need to go to your"
	echo "settings app and ensure that \"Smart screen mode\" is enabled."
	echo
	echo "Settings - Display - Screen mode - Smart screen mode"
	echo
	pause 'Press [Enter] key to move on.';
	if [ "$ALLOW_CLEAR" -gt "0" ]; then clear; fi
	echo "Upgrading.  Please wait..."
	echo
	adbCall "shell rm /system/framework/android.policy.jar"
	adbCall "push status/android.policy.jar /system/framework/android.policy.jar"
	adbCall "shell chmod 644 /system/framework/android.policy.jar"
	adbCall "shell chown 0.0 /system/framework/android.policy.jar"
	adbCall "shell rm /system/app/Settings.apk"
	adbCall "push status/Settings.apk /system/app/Settings.apk"
	adbCall "shell chmod 644 /system/app/Settings.apk"
	adbCall "shell chown 0.0 /system/app/Settings.apk"
	echo
	echo "Done. Rebooting..."
	adbCall "reboot"
	menu;
}

finish() {
	clearAndDisplayHeader;
	echo "And your done! That wasn't so hard was it."
	echo
	echo "Remember, you will need to reconfigure your input settings for your emulators"
	echo "if you have run the patch keypad option 1."
	echo
	echo "Huge thanks to Furan, Willgoo, fatesausage, Moorthy, Bondo2, Ivanz, Deen0X"
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
echo "This script is a super highway to to awesome for your Droid X360! This script"
echo "was designed SPECIFICALLY for the DROID X360.  Do not attempt to use it on any"
echo "other device. This script may void your warranty and I take no responsiblity"
echo "for any damage or data loss caused."
echo
echo "                 READ THE README.TXT BEFORE USING THIS SCRIPT"
echo
echo "Have you?"
echo
echo "- Installed adb linux platform tools?"
echo "- Configured udev for your device (may not be mandatory)"
echo "- Enabled USB Debugging?"
echo "- Connected your DROID X360 via USB?"
echo "- Removed any external SD card?"
echo
echo "Yes? Good."
pause 'Press [Enter] key to move on.';
menu;
