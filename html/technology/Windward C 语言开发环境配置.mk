# Windward C 语言开发环境配置

#### 1、下载安装 MSYS2

MSYS2官方网站：http://www.msys2.org/

清华大学开源镜像：https://mirrors.tuna.tsinghua.edu.cn/help/msys2/

#### 2、修改软件源：
可修改 中科大源 或者 清华大学 源

#### 3、配置更新

执行     
pacman -Sy 刷新软件包数据即可。

执行    
pacman-key --init

pacman -Syu 

>更新软件，更新过程中可能要求重新打开终端，另外更新的时候，pacman的软件源可能恢复到默认，需要手动再修改一次。

#### 4、安装工具链
1.  pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-extra-cmake-modules
2.  pacman -S mingw-w64-x86_64-make
2.  pacman -S mingw-w64-x86_64-gdb
2.  pacman -S mingw-w64-x86_64-toolchain

>命令出错可重新执行。

#### 5、安装GTK3及其依赖项

运行：    
pacman -S mingw-w64-x86_64-gtk3










