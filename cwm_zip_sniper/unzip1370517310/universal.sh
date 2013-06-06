#!/sbin/sh

cat /system/build.prop > /system/build.prop1
echo -e "\n" >> /system/build.prop1
echo -e "# SONY Media Applications Properties By Rizal Lovins" >> /system/build.prop1
echo -e "# Mobile Bravia Engine 2" >> /system/build.prop1
echo -e "ro.service.swiqi2.supported=true" >> /system/build.prop1
echo -e "persist.service.swiqi2.enable=1" >> /system/build.prop1
echo -e "" >> /system/build.prop1
echo -e "# Sony Clear Audio+" >> /system/build.prop1
echo -e "ro.semc.sound_effects_enabled=true" >> /system/build.prop1
echo -e "ro.semc.xloud.supported=true" >> /system/build.prop1
echo -e "persist.service.xloud.enable=1" >> /system/build.prop1
echo -e "ro.semc.enhance.supported=true" >> /system/build.prop1
echo -e "persist.service.enhance.enable=1" >> /system/build.prop1
echo -e "ro.semc.clearaudio.supported=true" >> /system/build.prop1
echo -e "persist.service.clearaudio.enable=1" >> /system/build.prop1
echo -e "ro.sony.walkman.logger=1" >> /system/build.prop1
echo -e "persist.service.walkman.enable=1" >> /system/build.prop1
echo -e "ro.somc.clearphase.supported=true" >> /system/build.prop1
echo -e "persist.service.clearphase.enable=1" >> /system/build.prop1
echo -e "" >> /system/build.prop1
echo -e "# SONY Audio Resampling" >> /system/build.prop1
echo -e "af.resampler.quality=255" >> /system/build.prop1
echo -e "persist.af.resampler.quality=255" >> /system/build.prop1
echo -e "persist.audio.samplerate=48000" >> /system/build.prop1
echo -e "persist.af.resample=48000" >> /system/build.prop1
echo -e "" >> /system/build.prop1
echo -e "# System prop to select MPQAudioPlayer by default on mpq8064" >> /system/build.prop1
echo -e "mpq.audio.decode=true" >> /system/build.prop1
echo -e "\n" >> /system/build.prop1
rm /system/build.prop
mv /system/build.prop1 /system/build.prop
