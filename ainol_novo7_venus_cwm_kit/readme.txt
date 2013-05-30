 _    __                     
| |  / /__  ____  __  _______
| | / / _ \/ __ \/ / / / ___/
| |/ /  __/ / / / /_/ (__  ) 
|___/\___/_/ /_/\__,_/____/  
                             

Thank you for downloading the CWM Recovery for Venus package.

A note from bnmguy
"This is for the Hero II. It may work with other devices as well, but I 
have not tested with them, nor have I even looked at any possible 
compatibility issues with them. If you decide to use this on them, I 
will not be able to help you if something goes wrong.

Please note, this is still an early build and WILL have some bugs. I am 
not responsible if it breaks your device. Flash at your own risk!!!

What's not working
USB Mounting
Reboot Recovery (Don't try it!)
Maybe other things?"

Credits:

CWM Recovery for Venus packed by Cloud Deter.

ClockworkMod Recovery early build developed by bmnguy.

Batch file by Cloud Deter - based from cxz's commands.

Linux batch by Nikojiro - based on Cloud Deter's DOS batch.

--------------------------------------------------------------------------------
-- Linux instructions
--------------------------------------------------------------------------------

First you need to have root access or be a sudoer (e.g. be able to use the 'sudo' command).
You'll also need to install ADB (see http://developer.android.com/sdk/index.html)

1.  Plug your tablet on your PC's via USB
2.  Open a terminal and type 'lsusb', you should see the following output, or very similar:
3.  As root, open the file /etc/udev/rules.d/51-android.rules with a text editor, create it 
    if it doesn't exist
4.  Add the following line
    SUBSYSTEMS==”usb”, ATTRS{idVendor}==”0x10d6", MODE=”0666″
5.  Save the file
5.  Note that the hex should match the one from 'lsusb' ouput, in this case '10d6'
6.  Open the file ~/.android/adb_usb.ini (no need to be root as it's in your home directory)
7.  Even though Google tells you not to edit this file, add the line "0x10d6" (or the hex you got previously)
8.  Save the file
9.  Navigate to where you extracted this kit
10. Open recovery_installer.sh in a text editor
11. Set the ADB_PATH variable to where the adb binary is located, in my case '~/dev/adt-bundle-x86/sdk/platform-tools'
12. Run ./recovery_installer.sh as root (log as root or use sudo)



