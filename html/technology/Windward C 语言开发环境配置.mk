# Windward C 语言开发环境配置

#### 1、下载安装 MSYS2

MSYS2官方网站：http://www.msys2.org/

清华大学开源镜像：https://mirrors.tuna.tsinghua.edu.cn/help/msys2/

中国科学技术大学源 https://mirrors.ustc.edu.cn/help/msys2.html
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


步骤5（可选）：安装构建工具
如果要用其他语言（例如C，C ++，Fortran等）开发GTK3应用程序，则需要像gcc和其他开发工具这样的编译器：
pacman -S mingw-w64-x86_64-toolchain base-devel




#### 6、在做GTK开发时隐藏 cmd窗口的办法
1. 第一种：CMakeLists.txt
    ```
   # cmake所需的最低版本
   cmake_minimum_required(VERSION 3.13)
   # naming项目
   project(test)
   
   # 指定编译器
   # CMAKE_C_FLAGS_DEBUG            ----  C 编译器
   # CMAKE_CXX_FLAGS_DEBUG        ----  C++ 编译器
   # -g：只是编译器，在编译的时候，产生调试信息。
   # -Wall：生成所有警告信息。一下是具体的选项，可以单独使用
   set(CMAKE_C_STANDARD 11)
   
   # 使用包PkgConfig检测 GTK+ 头文件/库文件
   find_package(PkgConfig REQUIRED)
   pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
   # 配置加载native依赖
   # CMake使用GTK +，告诉编译器在哪里查找头文件
   # 和链接器在哪里查找库文件
   include_directories(${GTK3_INCLUDE_DIRS})
   link_directories(${GTK3_LIBRARY_DIRS})
   
   # 将其他标志添加到编译器
   add_definitions(${GTK3_CFLAGS_OTHER})
   
   # 添加从hello.c编译的可执行文件
   add_executable(test main.c)
   # 与上面的区别在于：这意味着您将使它成为Windows程序，并提供WinMain函数(int main(int, char **)是入口点的控制台版本。int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int))。（可以隐藏CMD）
   #add_executable(test WIN32 main.c)
   
   # 链接库
   target_link_libraries(test ${GTK3_LIBRARIES})
   # 隐藏 CMD 
   target_link_options(test PRIVATE -mwindows)
    ```
2. 第二种
    1. 可以通过gcc实现：
    https://gcc.gnu.org/onlinedocs/gcc-4.4.2/gcc/i386-and-x86_002d64-Windows-Options.html
    ```
       gcc -mwindows -o simple simple.c
    ```
    2. 如果仍想通过gcc传递“ -mwindows”标志，但仍然使用“ main”，则只需将CMAKE_CXX_FLAGS和/或CMAKE_C_FLAGS值添加“ -mwindows”。您可以在cmake-gui程序中通过交互式调整这些变量以使其包含“ -mwindows”来执行此操作，也可以使用命令行CMake进行此操作，如下所示：
    ```
       cmake -DCMAKE_C_FLAGS="-mwindows"
    ```
   在 GUI 环境相同设置：
   ![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2020-03-04_184732.png)







