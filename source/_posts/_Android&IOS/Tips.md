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

## Mac
### Mac accept app from everywhere
```
sudo spctl --master-disable
```

### IOS reverse tools


## Debug
### [Solved] Apktool re-package apk failed
When unpack the apk, do no decode resources except manifest:
```
apktool d app-release_protected_signed.apk -r -o app-source -f --force-manifest
```

Build:
```
apktool b app-source -o app-debuggable.apk
```

### [Solved] Android studio dynamically debug app
Refer to [this article](https://cloud.tencent.com/developer/article/1877189). Firstly, we should unpack the apk file with apktoo and modify the `android:debuggable` property in  `AndroidManifest.xml` to 'true'. Re-pack the apk and sign it. 
Start the app in debug mode by running the activity manager:
```
adb shell am start -D -n  com.xxx/com.yitong.activity.SplashActivity
```
Import the "smali" folder of the apk extracted by apktool into Android Studio. Download "smalidea" plugin to add breakpoints on smali file. Attach to emulator process to start debugging. 


