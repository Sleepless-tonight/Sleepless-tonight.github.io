
偶然发现两个注册表分支中含有当前用户运行过的exe文件名，会在一定程度上造成信息泄露（仅在Windows10系统中测试过）

```
HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched
```

chkdsk d: /r

OSK.EXE 屏幕键盘
“osk.exe”
在命令提示符窗口输入"explorer.exe"启动桌面,成功进入SYSTEM账户桌面后按下“微软键+R"打开运行框,点击其中的“浏览" ,在打开的图形化窗口即可进行文件查找、浏览等操作
