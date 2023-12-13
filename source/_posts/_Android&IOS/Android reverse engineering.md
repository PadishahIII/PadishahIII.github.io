### Re-pack
After unpack the apk by apktool, modify the manifest to add debuggable tag. Then re-pack the folder.
```
apktool b <folder>
```
Then we need to generate a keystore.
```
keytool -genkey -alias t.keystore -keyalg RSA -validity 40000 -keystore t.keystore
```
Sign the apk with V1 signature.
```
jarsigner -keystore t.keystore -signedjar a_d_s.apk a_debuggable.apk t.keystore
```
Sign the apk with V2 signature.
```
apksigner sign --ks ~/Documents/t.keystore --ks-key-alias t.keystore --out Match_d_s_v2.apk Match_d_s.apk
```

Align apk:
check whether it is aligned:
```
zipalign -c -v 4 xx.apk
```
Align:
```
zipalign -p -f 4 xx.apk out.apk
```

Finally, we need to uninstall the original app completely and install the new apk.

### Dynamically debug using IDA

> [!NOTE] 
> Succeed on windows, with leidian emulator, take tan8 app as example.


1. Push the `android_server` program into the path of target app `/data/data/com.tan8` or `/data/local/tmp`, the latter path does not need root privilege. Start this program and it will listen on port 23946.
2. Do port forwarding. Run `adb forward tcp:<local-port> tcp:23946`.

After that, you can choose either to attach on an existing process(normal mode) or start the process in debuggable mode.
For normal mode, use IDA to attach to the target process and then you can start debug the native code.
For debuggable mode, you should firstly set the related system property `ro.debuggable` to 1. To do so, we can use `mprop` tool. Push the `mprop` script onto emulator and run `./mprop ro.debuggable 1` with root privilege. You have better to restart the emulator to get it into effect. Then run `adb shell am start -D -n com.tan8/com.tan8.ui.SplashActivity` to invoke the starter activity of target app in debuggable mode. Open DDMS and find the target process `com.tan8`, check its debug port(usually 86xx). Then get IDA attach to target process and push F9 to start debugging. Run `jdb -connect com.sun.jdi.SocketAttach:hostname=127.0.0.1,port=86xx` to start java debugging process and the app will move on into the normal activity.

### Frida spawn mode
```
frida  -f com.nbbank -l printActivities.js -H 127.0.0.1:8888
or
objection -p 8889 -h 127.0.0.1 -N -g bishe.networkmonitor explore
```

## Proxy and Capture traffic

### Proxy with Charles
#### Import system certificate
Export the certificate of Charles and run the command below to transform DER certificate to PEM. 
```
openssl x509 -inform DER -in cert.cer -out cacert.pem
```
Get MD5 hash head:
```
openssl x509 -inform PEM -subject_hash_old -in cacert.pem
```
Rename the pem file to `<hash>.0` like `fbb5727a.0`. Push the certificate to `/system/etc/security/cacerts/` and change its privilege to 644. Reboot the phone and you can check it in the system-trusted certificate list.


### Proxify foreign app 
We need to capture the network flow of the target app, while the app requires overseas VPN. After some tests, I choose to this method: ProxyDroid -> Charles -> Clash.
Firstly, we should configure ProxyDroid to connect to the SOCKS proxy of Charles, normally 8889 port. And specify the `Bypass Addresses` attribute as `127.0.0.1/24, 10.96.9.0/17, 10.96.4.0/17`(the IP ranges of WLAN).
Then configure Charles to open SOCKS proxy in `Proxy Setting` panel. And set `External proxy setting` to direct traffic to the upstream server i.e. Clash. 
Clash should unselect the `system proxy` attribute and set the proxy mode to `Global`. Finally, the target app can work normally with Clash and we can capture the https traffic.
Note that, if Frida cannot connect to the server after set up proxy, it may be caused by the confliction with ProxyDroid, you need to fix the `Bypass Addresses` of ProxyDroid to the correct value.

### Set ro.debuggable
Use MagiskHidePropsConf.

### Mitmproxy
Charles -> Mitmproxy -> Burp
```
mitmproxy -s mitm.py --listen-host 0.0.0.0 -p 8001 --mode upstream:http://127.0.0.1:8080 -k
```
Or
```
mitmweb -s mitm.py --listen-host 0.0.0.0 -p 8001 --mode upstream:http://127.0.0.1:8080 -k --set web_port=8082
```

## Deal with traffic encryption
### Frida&Burp
[repo](https://github.com/noobpk/frida-intercept-encrypted-api)
#### **Hook Encryption**
Entrance of **Encrypt()** →
frida-server, hook raw param →(rpc) python frida client →(http) burp →(http) echo server, reply with request →
**Encryption** on modified params

#### Hook Decryption
Entrance of **Decrypt()** →
Decryption on encrypted data →
frida-server, hook raw param →(rpc) python frida client →(http) burp →(http) echo server, reply with request →
Return modified data(HTTP response)

#### Launch Step
1. Start frida-server on phone
2. Burp set listener on port `127.0.0.1:26080`
3. Burp set `Redirect` to `127.0.0.1:27081`
4. (Optional) Launch mitmproxy on port 27081 and redirect to 27080, `mitmproxy -s mitm.py --listen-host 0.0.0.0 -p 27081 --mode upstream:http://127.0.0.1:27080 -k`
5. Adb forward frida port, `adb forward tcp:27042 tcp:27042`
6. Launch the echo server on port 27080, `python echoServer.py`
7. Launch frida client, `python burpTracer.py -s hook.js -n 弹琴吧`(attach mode, set `-p` to spawn)
8. Intercept the raw request before encryption on Burp.

---

# Unity Reverse Engineering
## IL2Cpp reverse engineering
### Overview
IL2cpp packing has two features:
1. `assets/bin/Data/Managed/Metadata/global-metadata.dat`, contains symbol informations such as class definition, method signature.
2. `lib/libil2cpp.so`, contains the logics but without symbol.

### Extract DAT file and libil2cpp.so
Use GameGuardian and run [libdumper script]([https://d.gameguardian.net](https://d.gameguardian.net/?f=2740_1B6C.8pQPxsSWhMiuz80GzrX2ZCYaC88nUa8eoTakLQ8r.kvqEINKGgobnH3znYsDskXStiL3nxjb1YR_etc291HAF8emUmfDqfcsVclOEc9ieCkQBFiyuuSCJSGzLqaty0HgDALAi1wQam3UMMh_gR2lHmN856VbvHLy4dfZkj4oHudNsUBliDMyeImVdQY9_0w07X8DTB.4vc-) to dump DAT and `libil2cpp.so` in memory.
### Decompile using `Il2cppDumper`
Run [Il2cppDumper](https://github.com/Perfare/Il2CppDumper) with the two files as input, it would generate `script.json` and all DLL files. Use `ILSpy` to inspect the `Assembly-CSharp.dll`. Run IDA script `ida_with_struct_py3.py` which is within the github files, with `script.json` as input to load symbols for IDA.

### Hook using `frida-il2cpp-bridge`
Firstly, trace all methods to locate key functions. Then you can hook as a normal app.
