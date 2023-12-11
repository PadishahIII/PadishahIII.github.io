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
**dumpDex Failed**
**frida-dexdump Failed to dump tan8 package**
**mHook not worked**
**BlackDex not worked(crash on unshelling)**

### Runtime Protection
```
padishah@Harris Frida_WorkSpace % frida -f com.tan8 -U -l fridaBypass.js 
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
   . . . .   Connected to Pixel 3 (id=8B7X14VWS)
Spawned `com.tan8`. Resuming main thread!                               
[Pixel 3::com.tan8 ]-> strcmp-> Lde/robv/android/xposed/XSharedPreferences;;;; Lde/robv/android/xposed/XSharedPreferences;
strcmp-> Lde/robv/android/xposed/callbacks/XC_LayoutInflated;;;; Lde/robv/android/xposed/callbacks/XC_LayoutInflated;
strcmp-> Lde/robv/android/xposed/callbacks/XC_LayoutInflated$Unhook;;;; Lde/robv/android/xposed/callbacks/XC_LayoutInflated$Unhook;
strcmp-> Lde/robv/android/xposed/XC_MethodHook$Unhook;;;; Lde/robv/android/xposed/XC_MethodHook$Unhook;
load:/system/framework/oat/arm64/org.apache.http.legacy.odex
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/oat/arm64/base.odex
android version 11
strcmp-> Lde/robv/android/xposed/callbacks/XCallback$Param;;;; Lde/robv/android/xposed/callbacks/XCallback$Param;
strcmp-> Lde/robv/android/xposed/XposedInit$2;;;; Lde/robv/android/xposed/MethodHooker;
open hooked-> /proc/self/cmdline
open hooked-> /data/data/com.tan8/.jiagu/libjiagu.so
open hooked-> /data/data/com.tan8/.jiagu/libjiagu_64.so
load:/data/data/com.tan8/.jiagu/libjiagu_64.so
open hooked-> /proc/self/status
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
open hooked-> /proc/self/maps
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/oat/arm64/base.odex
open hooked-> /proc/self/cmdline
strstr-> /apex/com.android.art/javalib/boot.art];;; io.va.exposed
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libjgdtc.so
open hooked-> /system/lib64/libjgdtc.so
open hooked-> /system_ext/lib64/libjgdtc.so
open hooked-> /product/lib64/libjgdtc.so
load:libjgdtc.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libjgdtc.so
strcmp-> Lcom/google/gson/annotations/Expose;;;; Lcom/google/gson/annotations/Expose;
[Pixel 3::com.tan8 ]-> open hooked-> /proc/tty/drivers
open hooked-> /proc/cpuinfo
[Pixel 3::com.tan8 ]-> open hooked-> /proc/self/cmdline
open hooked-> /proc/self/cmdline
open hooked-> /proc/22507/cmdline
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libBugly-ext.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libBugly-ext.so
open hooked-> /proc/22507/maps
open hooked-> /proc/meminfo
open hooked-> /proc/self/cmdline
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libumeng-spy.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libumeng-spy.so
open hooked-> /proc/cpuinfo
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libmidiSynth.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libmidiSynth.so
open hooked-> /proc/cpuinfo
load:/vendor/lib64/hw/gralloc.sdm845.so
load:/vendor/lib64/hw/android.hardware.graphics.mapper@2.0-impl-qti-display.so
open hooked-> /proc/self/cmdline
open hooked-> /proc/self/cmdline
open hooked-> /proc/self/cmdline
open hooked-> /proc/22923/timerslack_ns
open hooked-> /proc/22924/timerslack_ns
open hooked-> /proc/22925/timerslack_ns
open hooked-> /proc/22927/timerslack_ns
open hooked-> /proc/22926/timerslack_ns
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libtan8guitar.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libtan8guitar.so
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libclib.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libclib.so
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libdzqLibrary.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libdzqLibrary.so
open hooked-> /proc/22943/timerslack_ns
open hooked-> /proc/22945/timerslack_ns
open hooked-> /proc/22944/timerslack_ns
open hooked-> /proc/22947/timerslack_ns
open hooked-> /proc/22948/timerslack_ns
open hooked-> /proc/22946/timerslack_ns
open hooked-> /proc/22951/timerslack_ns
open hooked-> /data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libmsc.so
load:/data/app/~~GBxWEqPwE_AOu0z0NerBmQ==/com.tan8-Glbo378AoaMloOBUJeHEFA==/lib/arm64/libmsc.so
load:/vendor/lib64/hw/android.hardware.renderscript@1.0-impl.so
open hooked-> /proc/cpuinfo
open hooked-> /proc/cpuinfo
open hooked-> /proc/cpuinfo
open hooked-> /proc/cpuinfo
open hooked-> /proc/cpuinfo
open hooked-> /proc/cpuinfo
```

### Capture traffic
When request a free score:
![[Pasted image 20231211162704.png]]

CheckYuePu:
![[Pasted image 20231211162719.png]]

Download:

![[Pasted image 20231211162412.png]]

Whole:
![[Pasted image 20231211163023.png]]

### Trace
Frida-trace:
```
#Spawn and bypass:
frida -f com.tan8 -U -l fridaBypass.js
#Attach:
frida-trace -F -U -j "com.tan8*\!*" -J "com.tan8.service*\!*"
```

r0tracer:
```
frida -l r0tracer.js -U -f com.tan8
```


---

## Yalla SRC
### Yalla
No shell
Obfuscated by proguard
Cannot run in Noxplayer, can run in AVD

**Hook:** Frida spawn and objection attach, objection successfully inspect all activities at the start page.

**Sniff:** 
- Test on huawei phone, cannot proxy the network flow, may using okhttp
- Failed with drony
- [ ] Try httpcanary

### Okey101
No shell
SSL pinning, r0capture not worked
- [x] Android11 is too high to add system certificate
Add charles certificate to system and proxy yalla successfully.
Network overtime when using burp proxy.
`TrustManagerImpl` is called. Try extracting the args. There is harden facilities on server certificates, but cannot locate corresponding code. Cannot proxy the "兑换码" network request, maybe under protection.


### Match
"HttpRequestMgr::GetNonce": x-hera
x-baggage: JWT of nonce, **this header is just a base64-encoded json, without signature**.
Post body is the result of `Framework.Common.MD5Helper::DoAesEncrypt` whose key and iv is dynamically changed. Key is from MD5(nonce). IV is generated from key, with 4 bytes tripped from head and tail.
Nonce can re-use.
MD5 Salt: `urCpW8t7vGQ23sD8`
- [ ] Cannot reproduce MD5 encrypting function.
Use ASCII encoding when encode x-baggage.
- [ ] MD5 alg is re-written. 
- [ ] MD5 maybe not re-written, the byte array get hooked is just partial. The To16Array in C is just one-byte-different from that of target.


---


# Journal
- [ ] (Tan8) IDA does not have "Remote Android Debugger" option, try to debug on windows
	- [x] On windows, run android_x64_server with "remote linux debugger" in IDA, can attach to process
	- [ ] On mac, only android_server64 is compatible with emulator, with "remote gdb debugger" in IDA, but can not attach to any process
	- [x] [Failed] Push IDA server to `/data/data/com.tan8` and the root procession can be ignored. Try in your phone.
	- [ ] On windows, when get IDA dynamically debug tan8 app, SIGILL exception occurred. May be wrong with Leidian emulator and Noxplayer. If use AVD, IDA would crack right after execute "attach to process".
	- [ ] On windows, the above problems remain even if it comes to my network-monitor app hardened by bangbang. **In conclusion, any emulator has failed to support dynamical debugging of IDA over either bangbang or 360 harden. Try dynamical debug in a real phone.**
