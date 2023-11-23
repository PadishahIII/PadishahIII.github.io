### Re-pack
After unpack the apk by apktool, modify the manifest to add debuggable tag. Then re-pack the folder.
```
apktool b <folder>
```
Then we need to generate a keystore.
```
keytool -genkey -alias t.keystore -keyalg RSA -validity 40000 -keystore t.keystore
```
Sign the apk.
```
jarsigner -keystore t.keystore -signedjar a_d_s.apk a_debuggable.apk t.keystore
```
Align apk:
check whether it is aligned:
```
zipalign -c -v 4 xx.apk
```
Align:
```
zipalign -p -f xx.apk out.apk
```

Finally, we need to uninstall the original app completely and install the new apk.

### Dynamically debug using IDA

> [!NOTE] 
> Succeed on windows, with leidian emulator, take tan8 app as example.


1. Push the `android_server` program into the path of target app `/data/data/com.tan8` or `/data/local/tmp`, the latter path does not need root privilege. Start this program and it will listen on port 23946.
2. Do port forwarding. Run `adb forward tcp:<local-port> tcp:23946`.

After that, you can choose either to attach on an existing process(normal mode) or start the process in debuggable mode.
For normal mode, use IDA to attach to the target process and then you can start debug the native code.
For debuggable mode, you should firstly set the related system property `ro.debuggable` to 1. To do so, we can use `mprop` tool. Push the `mprop` script onto emulator and run `./mprop ro.debuggable 1` with root privilege. You have better to restart the emulator to get it into effect. Then run `adb shell am start com.tan8/com.tan8.ui.SplashActivity` to invoke the starter activity of target app in debuggable mode. Open DDMS and find the target process `com.tan8`, check its debug port(usually 86xx). Then get IDA attach to target process and push F9 to start debugging. Run `jdb -connect com.sun.jdi.SocketAttach:hostname=127.0.0.1,port=86xx` to start java debugging process and the app will move on into the normal activity.

### Frida spawn mode
```
frida  -f com.nbbank -l printActivities.js -H 127.0.0.1:8888
or
objection -p 8889 -h 127.0.0.1 -N -g bishe.networkmonitor explore
```

