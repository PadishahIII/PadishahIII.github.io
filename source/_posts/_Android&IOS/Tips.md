## ADB
1. Get system arch type : `getprop ro.product.cpu.abilist`

## Android studio emulator
### [Solved] "Read-only system" issue
Close emulator and run:
```
~/Library/Android/sdk/emulator/emulator -writable-system -avd Pixel_6a_API_34 
```
In another terminal:
```
adb remount
```




### [Solved] "/system/frida-server: No such file or directory"
```
1|generic_arm64:/system # /system/sss
/system/bin/sh: /system/sss: No such file or directory
1|generic_arm64:/system # ls /system/sss
/system/sss
generic_arm64:/system #
```
There is exactly a frida server in /system but this issue occurs when run it. 

**Solution**: The frida server is in wrong architecture from that of emulator, and it is notable that "arm" differs from "arm64"

### [Solved] Read-only file system on real phone
```
mount -o rw,remount /
```

### [Solved] ADB install "error Incremental installation not allowed"
```
adb install -r --no-incremental Match_d_s_v2.apk
```

## Mac
### Mac accept app from everywhere
```
sudo spctl --master-disable
```

### IOS reverse tools


## Debug&Repack
### [Solved] Apktool re-package apk failed
When unpack the apk, do no decode resources except manifest:
```
apktool d app-release_protected_signed.apk -r -o app-source -f --force-manifest
```

Build:
```
apktool b app-source -o app-debuggable.apk
```

### [Solved] Apktool re-pack "error: attribute xxx not found"
Empty framework dir by:
```
apktool empty-framework-dir
```
Re-pack:
```
apktool b  YallaMatch_original -o Match_r.apk [--use-aapt2]
```


### [Solved] Android studio dynamically debug app
Refer to [this article](https://cloud.tencent.com/developer/article/1877189). Firstly, we should unpack the apk file with apktoo and modify the `android:debuggable` property in  `AndroidManifest.xml` to 'true'. Re-pack the apk and sign it. 
Start the app in debug mode by running the activity manager:
```
adb shell am start -D -n  com.xxx/com.yitong.activity.SplashActivity
```
Import the "smali" folder of the apk extracted by apktool into Android Studio. Download "smalidea" plugin to add breakpoints on smali file. Attach to emulator process to start debugging. 

### [Solved] adb install "Failure INSTALL_FAILED_UPDATE_INCOMPATIBLE: Package com.uusafe.portal signatures do not match previously installed version;"
Uninstall the original app completely and try again.

### [Solved] DDMS monitor.exe start error on windows
DDMS only supports JDK8. You should copy the `jre` folder of JDK into the path monitor.exe locates. It's noticeable that `jenv` can not work out this problem.

### [Solved] DDMS fails to show procession names on windows
All procession names are `?` in DDMS. You should set the system property `ro.debuggable` to 1, ensure the emulator is rooted, and restart DDMS.

## Android
### [Solved] Remount failed: read-only file system
On pixel3 android11, I intend to add charles certificate as system certificate, but when push the cer file into /system/security/xxx, an error occurred: "/dev/xx/dm-0 read-only file system". **This feature is added in android10 that all system file partitions are read-only.** After checking the /proc/mounts file, there is no /system mount. So, we need to unlock the system partition. After tons of searching work, I found [this tool](https://github.com/HuskyDG/magic_overlayfs/tree/v3.2.2). Update magisk to 23+ and install this module. Remount the system partitions to rw by running :
```
su -mm -c magic_remount_rw
```
Restore to ro by running:
```
su -mm -c magic_remount_ro
```
Finally, i can push my certificate into system certificate folder.(Note that, the /system folder is still read-only but its subfolders are read-writable.)

### [Solved] Frida conflict with MagiskHide
Frida throw error: "no process" when MagiskHide is open. Solution is open Zygisk+SuList to replace MagiskHide, frida runs normally.

## Hook
### [Solved] Frida conflicted with VPN
When set VPN by ProxyDruid, frida would not able to connect to the frida-server normally. We need to add bypass list: `127.0.0.1/24, 10.96.9.0/17, 10,96.4.0/17`. After that, frida can connect normally.
