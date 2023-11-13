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
jarsigner -keystore t.keystore -signedjar a_d_s.apk a_debuggable.apk
```
Finally, we need to uninstall the original app completely and install the new apk.