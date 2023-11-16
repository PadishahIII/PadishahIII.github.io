## [内部] 宁波银行App

**Protections: **
Hardened by "bangbang"
Check root, but just warn
Crash on frida connection

**Result: ** Bypass anti-root and anti-frida

### Unpacking using frida-dexdump
Unshell successfully by using hluda-server to bypass anti-frida and using frida-dexdump to dump dexes.

Frida spawn mode works. Running:
```
frida  -f com.nbbank -l printActivities.js -H 127.0.0.1:8888
or
objection -p 8889 -h 127.0.0.1 -N -g bishe.networkmonitor explore
```


### Bypass anti-frida
Use hluda-server to bypass detection. Get a galance at the anti-frida methods of this app.
Update: Frida hook dlopen functions:
```
padishah@Harris Frida_WorkSpace % frida -H 127.0.0.1:3333 -f com.nbbank -l fridaBypass.js
     ____
    / _  |   Frida 16.1.5 - A world-class dynamic instrumentation toolkit
   | (_| |
    > _  |   Commands:
   /_/ |_|       help      -> Displays the help system
   . . . .       object?   -> Display information about 'object'
   . . . .       exit/quit -> Exit
   . . . .
   . . . .   More info at https://frida.re/docs/home/
   . . . .
   . . . .   Connected to 127.0.0.1:3333 (id=socket@127.0.0.1:3333)
Spawning `com.nbbank`...                                                
 Activity enumertion complete
Spawned `com.nbbank`. Resuming main thread!                             
[Remote::com.nbbank ]-> load:/system/framework/oat/arm64/org.apache.http.legacy.odex
android version 10
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libDexHelper.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libPassGuard.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libsqlcipher.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libmmkv.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libdexjni.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libio-canary.so
load:/data/dalvik-cache/arm64/system@app@TrichromeLibrary@TrichromeLibrary.apk@classes.dex
load:/data/dalvik-cache/arm64/system@app@WebViewGoogle@WebViewGoogle.apk@classes.dex
load:libmonochrome.so
load:/system/app/WebViewGoogle/WebViewGoogle.apk!/lib/arm64-v8a/libmonochrome.so
load:/system/lib64/libwebviewchromium_plat_support.so
load:/vendor/lib64/hw/gralloc.sdm845.so
load:/vendor/lib64/hw/android.hardware.graphics.mapper@2.0-impl-qti-display.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libWangyinCryptoLib.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libyt_safe.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libnllvm1624117532.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libpnc-crypto.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libxdkj.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libhke.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libfs-pnc-crypto.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libupwallet.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libupsdkencrypt.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libxdjacrypto.so
load:/data/app/com.nbbank-E7rTQj-iee_uIYRRrpTElA==/lib/arm64/libzxprotect.so
Connection terminated
[Remote::com.nbbank ]->

Thank you for using Frida!
```

Inspect certain objects in heap:
![[Pasted image 20231110115136.png]]

~~Any hook does not work.~~
~~The main process would terminate for several times after frida spawned:~~(This problem is caused by the string compare hook, fixed)
![[Pasted image 20231110115624.png]]

String compare native hook works. But the hook for `open` method would cause process termination on the fly. The available intelligence is as below:
```
open hooked-> /proc/self/cmdline
load:/system/framework/oat/arm64/org.apache.http.legacy.odex
load:libframework-connectivity-jni.so
open hooked-> /proc/self/exe
open hooked-> /data/app/~~Uzw4kdmPhc4QrTg-P28k6g==/com.nbbank-lFg-JAENXtlzfVb29GyWbA==/lib/arm64/libDexHelper.so
load:/data/app/~~Uzw4kdmPhc4QrTg-P28k6g==/com.nbbank-lFg-JAENXtlzfVb29GyWbA==/lib/arm64/libDexHelper.so
open hooked-> /system/lib/libc.so
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/cmdline
Process terminated
```
As for the string comparation hook, only `frida-agent` feature is detected:
```
strstr-> 12c00000-52c00000 rw-p 00000000 00:00 0                                  [anon:dalvik-main space (region space)]
;;; frida-agent
```


Interesting log:
```
11-10 12:25:47.854 12881 12881 V Matrix.IOCanaryJniBridge: install sIsTryInstall:false
11-10 12:25:47.890 12881 12881 D IOCanary.JNI: JNI_OnLoad
11-10 12:25:47.893 12881 12881 D IOCanary.JNI: JNI_OnLoad done
11-10 12:25:47.895 12881 12881 I IOCanary.JNI: doHook
11-10 12:25:47.895 12881 12881 I IOCanary.JNI: try to hook function in libopenjdkjvm.so.
11-10 12:25:47.902 12881 12881 I IOCanary.JNI: try to hook function in libjavacore.so.
11-10 12:25:47.910 12881 12881 I IOCanary.JNI: try to hook function in libopenjdk.so.
11-10 12:25:47.914 12881 12881 I IOCanary.JNI: doHook done.
11-10 12:25:47.915 12881 12881 I Matrix.CloseGuardHooker: hook sIsTryHook=false
```

Using `stackplz` to trace the detection of `/proc/self/maps`:
```
/system/stackplz -n com.nbbank  --point open[str,int] --stack --regs --filter w:/proc
```
![[Pasted image 20231110134002.png]]

### Bypass anti-root
This App detects root environment by access file `/system/bin/su`.



## Tan8
### Unshell
In `com.stub.StubApp` class, move `libjiagu.so` in assets folder to `.jiagu/libjiagu.so`, and load



# Journal
- [ ] (Tan8) IDA does not have "Remote Android Debugger" option, try to debug on windows
	- [x] On windows, run android_x64_server with "remote linux debugger" in IDA, can attach to process
	- [ ] On mac, only android_server64 is compatible with emulator, with "remote gdb debugger" in IDA, but can not attach to any process
	- [x] [Failed] Push IDA server to `/data/data/com.tan8` and the root procession can be ignored. Try in your phone.