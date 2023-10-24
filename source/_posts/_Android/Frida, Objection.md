# Frida
## CMD Tools
- 



---

# Objection 
- `objection --gadget asvid.github.io.fridaapp explore`: enter
- `file download <remote path> [<local path>]`: 下载文件
- `file upload <local path> [<remote path>]`: 上传文件
- `import <local path frida-script>`: 导入 Frida 脚本
- `android sslpinning disable`: 禁用 Android 设备上的 SSL Pinning
- `android root disable`: 禁用 Android 设备上的 root 检测
- `android root simulate`: 模拟具有 root 权限的 Android 环境
- `android shell_exec whoami`: 执行 shell 命令 whoami
- `android ui screenshot /tmp/screenshot`: 截取 Android 设备屏幕截图
- `android ui FLAG_SECURE false`: 通过硬件键启用截屏功能
- `android hooking list activities`: 列出应用程序的活动
- `android hooking list services`: 列出应用程序的服务
- `android hooking list receivers`: 列出应用程序的接收器
- `android hooking get current_activity`: 获取当前活动
- `android hooking search classes <app_package>`: 搜索应用程序中的类
- `android hooking search methods <app_package> <class_name>`: 搜索应用程序中类的方法
- `android hooking list class_methods <app_package> <class_name>`: 列出类的已声明方法及其参数
- `android hooking list classes`: 列出已加载的类
- `android hooking watch class_method <app_package> <class_name>.<method_name> --dump-args --dump-backtrace --dump-return`: 监视方法并记录其参数、返回值和回溯信息
- `android hooking watch class <app_package> <class_name> --dump-args --dump-return`: 监视整个类并记录其方法的参数和返回值
- `android heap print_instances <class>`: show instance in heap