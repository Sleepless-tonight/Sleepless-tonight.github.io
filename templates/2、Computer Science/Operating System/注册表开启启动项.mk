## 注册表开启启动项

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run





一、经典的启动——“启动”文件夹

单击“开始→程序”，你会发现一个“启动”菜单，这就是最经典的Windows启动位置，右击“启动”菜单选择“打开”即可将其打开，其中的程序和快捷方式都会在系统启动时自动运行。

二、有名的启动——注册表启动项

注册表是启动程序藏身之处最多的地方，主要有以下几项：

1.Run键

Run键是病毒最青睐的自启动之所，该键位置是[HKEY_CURRENT_
USER\Software\Microsoft\Windows\CurrentVersion\Run]和[HKEY_
LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]，其下的所有程序在每次启动登录时都会按顺序自动执行。

还有一个不被注意的Run键，位于注册表[HKEY_CURRENT_
USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run]和[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\
Policies\Explorer\Run]，也要仔细查看。

2.RunOnce键

RunOnce位于[HKEY_CURRENT_USER\Software\Microsoft\Windows\
CurrentVersion\RunOnce]和[HKEY_LOCAL_MACHINE\Software\Microsoft\
Windows\CurrentVersion\RunOnce]键，与Run不同的是，RunOnce下的程序仅会被自动执行一次。

3.RunServicesOnce键

RunServicesOnce键位于[HKEY_CURRENT_USER\Software\Microsoft\
Windows\CurrentVersion\RunServicesOnce]和[HKEY_LOCAL_MACHINE\
Software\Microsoft\Windows\CurrentVersion\RunServicesOnce]下，其中的程序会在系统加载时自动启动执行一次。

4.RunServices键

RunServices继RunServicesOnce之后启动的程序，位于注册表[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices]和[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\
RunServices]键。

5.RunOnceEx键

该键是Windows XP/2003特有的自启动注册表项，位于[HKEY_
CURRENT_USER\\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx]和[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx]。

6.load键
[HKEY_CURRENT_USER\Software\Microsoft\WindowsNT\CurrentVersion\Windows]下的load键值的程序也可以自启动。

7.Winlogon键

该键位于位于注册表[HKEY_CURRENT_USER\SOFTWARE\
Microsoft\Windows NT\CurrentVersion\Winlogon]和[HKEY_LOCAL_MACHINE\
SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]，注意下面的Notify、Userinit、Shell键值也会有自启动的程序，而且其键值可以用逗号分隔，从而实现登录的时候启动多个程序。

8.其他注册表位置

还有一些其他键值，经常会有一些程序在这里自动运行，如：[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\Shell]
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad]
[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System\Scripts]
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System\Scripts]

小提示：

注册表的[HKEY_LOCAL_MACHINE]和[HKEY_CURRENT_USER]键的区别：前者对所有用户有效，后者只对当前用户有效。

三、古老的启动——自动批处理文件

从DOS时代过来的朋友肯定知道autoexec.bat（位于系统盘根目录）这个自动批处理文件，它会在电脑启动时自动运行，早期许多病毒就看中了它，使用deltree、format等危险命令来破坏硬盘数据。如“C盘杀手”就是用一句“deltree /y c:\*.*”命令，让电脑一启动就自动删除C盘所有文件，害人无数。

小提示

★在Windows 98中，Autoexec.bat还有一个哥们——Winstart.bat文件，winstart.bat位于Windows文件夹，也会在启动时自动执行。
★在Windows Me/2000/XP中，上述两个批处理文件默认都不会被执行。

四、常用的启动——系统配置文件

在Windows的配置文件（包括Win.ini、System.ini和wininit.ini文件）也会加载一些自动运行的程序。

1.Win.ini文件

使用“记事本”打开Win.ini文件，在[windows]段下的“Run=”和“LOAD=”语句后面就可以直接加可执行程序，只要程序名称及路径写在“＝”后面即可。

小提示

“load=”后面的程序在自启动后最小化运行，而“run=”后程序则会正常运行。

2.System.ini文件

使用“记事本”打开System.ini文件，找到[boot]段下“shell=”语句，该语句默认为“shell=Explorer.exe”，启动的时候运行Windows外壳程序explorer.exe。病毒可不客气，如“妖之吻”病毒干脆把它改成“shell=c:\yzw.exe”，如果你强行删除“妖之吻”病毒程序yzw.exe，Windows就会提示报错，让你重装Windows，吓人不？也有客气一点的病毒，如将该句变成“shell=Explorer.exe 其他程序名”，看到这样的情况，后面的其他程序名一定是病毒程序如图2所示。

3.wininit.ini

wininit.ini文件是很容易被许多电脑用户忽视的系统配置文件，因为该文件在Windows启动时自动执后会被自动删除，这就是说该文件中的命令只会自动执行一次。该配置文件主要由软件的安装程序生成，对那些在Windows图形界面启动后就不能进行删除、更新和重命名的文件进行操作。若其被病毒写上危险命令，那么后果与“C盘杀手”无异。

小提示

★如果不知道它们存放的位置，按F3键打开“搜索”对话框进行搜索；
★单击“开始→运行”，输入sysedit回车，打开“系统配置编辑程序”，在这里也可以方便的对上述文件进行查看与修改。

五、智能的启动——开/关机/登录/注销脚本

在Windows 2000/XP中，单击“开始→运行”，输入gpedit.msc回车可以打开“组策略编辑器”，在左侧窗格展开“本地计算机策略→用户配置→管理模板→系统→登录”，然后在右窗格中双击“在用户登录时运行这些程序”，单击“显示”按钮，在“登录时运行的项目”下就显示了自启动的程序。

六、定时的启动——任务计划

在默认情况下，“任务计划”程序随Windows一起启动并在后台运行。如果把某个程序添加到计划任务文件夹，并将计划任务设置为“系统启动时”或“登录时”，这样也可以实现程序自启动。通过“计划任务”加载的程序一般会在任务栏系统托盘区里有它们的图标。大家也可以双击“控制面板”中的“计划任务”图标查看其中的项目。

小提示

“任务计划”也是一个特殊的系统文件夹，单击“开始→程序→附件→系统工具→任务计划”即可打开该文件夹，从而方便进行查看和管理.