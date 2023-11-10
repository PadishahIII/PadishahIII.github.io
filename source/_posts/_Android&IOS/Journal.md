
## TODO
- [ ] Write note for each version of app hardening
- [ ] Learn first generation of app shell [here](https://www.anquanke.com/post/id/247644)
- [ ] Learn different shelling method [here](https://juejin.cn/post/6962096676576165918)
- [ ] Shell and unshell your network-monitor app by different manufacturers 
- [x] Explore ways to unshelling using frida


## Issues about installing Magisk on Mac
1. Target app cannot run on genymotion, the emulator will crash at the start of target app
2. Genymotion cannot install magisk
3. Have tried `rootAVDs` tool on AVD and failed
4. Target app can run on AVD
5. Cannot push frida server onto AVD due to "Read-only system" cannot be modified
6. Fail to launch old version Xposed, Android studio cannot download system images with no reason, and an Android7 arm64 image is required
7. Fail to launch Magisk from `build.py` following [here](https://blog.mufanc.xyz/posts/52971059/)

## Things Done in Mac
1. Frida, objection can run normally
2. MT Explorer run normally
3. Android-Crack-Tools run normally


