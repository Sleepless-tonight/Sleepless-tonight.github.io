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
gpg: 警告：服务器 ‘gpg-agent’ 比我们的版本更老 （2.2.19-unknown < 2.2.20-unknown）
gpg: 注意： 过时的服务器可能缺少重要的安全修复。
gpg: 注意： 使用 “gpgconf --kill all” 来重启他们。

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



####  安裝文字介面下的純文字編輯器─vim
```
pacman -S vim
```


####  安裝 MinGW
```
pacman -S pacman -S mingw-w64-x86_64-toolchain
```


####  如果要查看目前工作目錄對應Windows環境的檔案路徑，可以再對「pwd」指令加上「-W」選項
```
pwd -W
```
####  更新MSYS2
```
pacman -Syu
```
更新到一半時，MSYS2可能會要求使用者要直接關閉MSYS2。

此時要用一般關閉視窗的方法來關閉MSYS2的終端機，而不要用「Ctrl+c」去中止MSYS2的更新程式。

關閉MSYS2後，重新開啟MSYS2的終端機，並輸入以下指令：

```
pacman -Su
```
接著繼續把套件的更新跑完。
#### 如何在MSYS2中編譯Rust程式
Windows作業系統中的Rust程式，預設會使用MSVC來編譯的。但是如果Rust程式有使用到GNU相關的函式庫(例如GTK)時，就得搭配MinGW來編譯了。MSYS2是一套整合MinGW和POSIX環境的工具，可以在Windows作業系統上模擬出Linux作業系統的開發環境，且能利用MinGW直接編譯出在Windows作業系統上執行的程式。

在Windows作業系統安裝Rust開發環境
如果您的Windows作業系統已經有Rust的開發環境(在命令提示字元下可以直接使用rustup、cargo等指令)，可以跳過這個部份。

首先在MSYS2的終端機上執行以下指令：
```
curl https://sh.rustup.rs -sSf | sh
```
1、安裝程式可能會提示說需要微軟的Visual C++ Build Tools。不要理它，輸入「y」繼續。

2、選擇第二個選項來自訂Rust要如何安裝。

3、host triple的部份，輸入「x86_64-pc-windows-gnu」，也就是我們的Rust編譯器預設使用的目標(target)名稱。

接著輸入Rust的版本，建議使用「stable」，如果有nightly需求的話就用「nightly」吧！
```
Default toolchain? (stable/beta/nightly/none)
nightly

Profile (which tools and data to install)? (minimal/default/complete)
complete

info: installing component 'cargo'
info: installing component 'clippy'
info: installing component 'llvm-tools-preview'
info: installing component 'miri'
info: installing component 'rls'
info: installing component 'rust-analysis'
info: installing component 'rust-docs'
info: installing component 'rust-mingw'
info: installing component 'rust-src'
info: installing component 'rust-std'
info: installing component 'rustc'
info: installing component 'rustc-dev'


```
4、接著設定是否要修改「PATH」環境變數，輸入「y」。

5、然後回到選單，選擇第一項，開始用我們剛才的設定來安裝Rust。

6、安裝好後，確認「PATH」環境變數是否有包含「%USERPROFILE%\.cargo\bin」路徑，沒有的話就加上去。

7、在命令提示字元中輸入「rustup」和「cargo」指令來確認Windows作業系統的Rust開發環境是否安裝且設定成功。如果有設定成功，指令才會存在。

8、此時可以在MSYS2的終端機中利用以下指令來查看「PATH」環境變數：
```
echo $PATH
```
9、之後就可以在MSYS2的終端機中使用「rustup」和「cargo」等Rust開發環境的相關指令了！
  
#### 替Rust加入「x86_64-pc-windows-gnu」目標
如果您在安裝Rust的時候已經設定使用了「x86_64-pc-windows-gnu」目標，可以跳過這個部份。

在MSYS2的終端機中使用以下指令，來查看Rust開發環境目前已加入的目標：
```
rustup toolchain list
```
如果沒有看到「x86_64-pc-windows-gnu」目標的話，可以使用以下指令來安裝：
```
rustup target add x86_64-pc-windows-gnu
```
讓Rust使用MinGW
在MSYS2的終端機中使用vim等文字編輯軟體，開啟「/c/Users/您的Windows使用者名稱/.cargo/config」檔案。
```
vim "/c/User/Magic Len/.cargo/config"
```
在檔案內加上以下內容：
```
[target.x86_64-pc-windows-gnu]
linker = "C:\msys64\mingw64\bin\gcc.exe"
ar = "C:\msys64\mingw64\bin\ar.exe"
```
如此一來，不論是哪個Cargo程式專案，在使用「x86_64-pc-windows-gnu」目標來編譯程式時，就會去用MinGW提供的「gcc.exe」和「ar.exe」來做函式庫的連結。

Rust與MSYS2的Hello World

為了確定我們的Rust開發環境沒有問題，可以在MSYS2的終端機中，使用以下幾個指令來測試預設的Cargo程式專案(Hello World)是否可以正常被編譯執行。
```
cargo new --bin hello
```
```
cd hello
```
```
cargo run
```














































