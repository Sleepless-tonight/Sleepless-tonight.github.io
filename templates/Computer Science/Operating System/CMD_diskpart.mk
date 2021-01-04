```
DISKPART> list disk

磁盘 ###  状态           大小     可用     Dyn  Gpt
  --------  -------------  -------  -------  ---  ---
磁盘 0    联机              238 GB      0 B        *
磁盘 1    联机              931 GB  1024 KB        *
* 磁盘 2    联机               14 TB  1024 KB        *
  磁盘 3    联机             7452 GB  7452 GB

DISKPART> list volume

卷 ###      LTR  标签         FS     类型        大小     状态       信息
  ----------  ---  -----------  -----  ----------  -------  ---------  --------
卷     0     G   系统           NTFS   磁盘分区         237 GB  正常
卷     1                      FAT32  磁盘分区         300 MB  正常         已隐藏
卷     2                      NTFS   磁盘分区         596 MB  正常         已隐藏
卷     3     C   系统           NTFS   磁盘分区         329 GB  正常         启动
卷     4     D   新加卷          NTFS   磁盘分区         599 GB  正常
卷     5                      NTFS   磁盘分区         596 MB  正常         已隐藏
卷     6                      FAT32  磁盘分区         300 MB  正常         系统
卷     7                      NTFS   磁盘分区         597 MB  正常         已隐藏
卷     8     E   新加卷          NTFS   磁盘分区          14 TB  正常

DISKPART> detail disk

JMicron H/W RAID5 SCSI Disk Device
磁盘 ID: {FE5CC930-993A-4CF0-96A0-32EE693BD091}
类型   : USB
状态 : 联机
路径   : 0
目标 : 0
LUN ID : 0
位置路径 : UNAVAILABLE
当前只读状态: 是
只读: 是
启动磁盘: 否
页面文件磁盘: 否
休眠文件磁盘: 否
故障转储磁盘: 否
群集磁盘  : 否

卷 ###      LTR  标签         FS     类型        大小     状态       信息
  ----------  ---  -----------  -----  ----------  -------  ---------  --------
卷     8     E   新加卷          NTFS   磁盘分区          14 TB  正常

DISKPART>  list partition

分区 ###       类型              大小     偏移量
  -------------  ----------------  -------  -------
* 分区      1    保留                  15 MB    17 KB
  分区      2    主要                  14 TB    16 MB



新磁盘首次被发现后，即被假定为 MBR 磁盘。在试图创建 GPT 分区之前，必须显式地将磁盘转换为 GPT。建议您将 MSR 创建为每个数据磁盘上的第一个分区以及任何系统或启动盘上的第二个分区（在 ESP 之后）。从 MBR 转换为 GPT 后，MSR 分区将在磁盘上自动创建。创建任何新的分区后，最近创建的分区会得到分区焦点。删除任何分区后，分区焦点也会丢失。磁盘焦点在任何情况下都保持不变。










取消只读模式步骤：

1、管理员模式打开 CMD；

2、输入 diskpart，回车；

3、输入 list volume 获得分区列表；

4、输入 select volume [number] 指定分区；
5、输入 attributes volume set readonly 设置只读模式。
5、输入 attributes volume clear readonly 取消只读模式。
```