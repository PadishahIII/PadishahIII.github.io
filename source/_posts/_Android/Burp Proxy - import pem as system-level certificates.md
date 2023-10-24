1. Export Burp cert as DER fomat
2. `openssl x509 -in .\cacert.der -inform der -outform pem -out .\cacert.pem` : Transfer `.der` to `.pem`
3. `openssl x509 -inform pem -subject_hash_old -in cacert.pen` : Get hash
4. Rename `cacert.pem` to `<hash>.0` and push it to android device: `adb push .\<hash>.0 /system/etc/security/cacerts/`
5. `chmod 644 <hash>.0` & `chgrp root <hash>.0`
6. Reboot
