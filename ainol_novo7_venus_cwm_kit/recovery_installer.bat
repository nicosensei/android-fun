@echo off
echo Venus CWM recovery install script by Cloud Deter.
echo Script based off cxz's commands.
echo Recovery by bnmguy.
echo Please wait while ADB starts and gains root...
adb root
adb wait-for-device
echo Making recovery directory...
adb shell busybox mkdir /mnt/obb/rec
echo Mounting recovery partition...
adb shell busybox mount -t vfat /dev/block/acta /mnt/obb/rec
echo Copying CWM to the recovery partition...
adb push recovery.img /mnt/obb/rec
echo Stopping ADB...
adb kill-server
echo Finished!
echo To access CWM recovery 'Power off' your Venus.
echo Then press and hold the VOLUME MINUS (-) key and the power button key.
pause