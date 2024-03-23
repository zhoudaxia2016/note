# 黑苹果&win双系统

## 硬件准备
- 移动固态硬盘
- nuc8i5beh
- 一台win电脑和一台mac电脑

## 步骤
- 制作Mac启动盘
这一步可在Mac上也可以在Win上操作。
在Mac：
  - softwareupdate --list-full-installers 查看可安装MacOS版本
  - softwareupdate --fetch-full-installer --full-installer-version 13.6.5 下载Ventura
  - 插入固态，找到固态对应的容器，格式化(抹掉)固态，分区格式为：MacOS日志扩展，Guid分区图。
  可能找不到Guid分区图这个选项，可能是选择了宗卷。需要在磁盘工具旁边的显示下拉菜单选择显示所有设备，顶层那个才是容器。

- copy EFI文件 这一步还不知道怎么在Mac上操作，暂时需要在Win上用DiskGenius。
  - 下载对应OpenCore EFI文件，以管理员权限打开DiskGenius，看到启动盘的EFI分区，
  删除里面所有文件，再将下载的EFI文件拖进去。

- 设置bios。直接在网上搜即可。

- 插入启动盘，bios选择U盘启动，即可进入mac系统安装界面。
  - 将硬盘抹除，格式为APFS。用macos日志式没有成功过。。按自己情况是全部抹除还是抹除一个分区。现在是演示从0开始装双系统，所以先全部抹掉。
  - 开始安装。然后会重新启动，不用拔掉U盘，会有好几次重启。然后就是系统设置，这一步没什么可以说的。
- 修复EFI启动。安装好mac后，暂时无法脱离u盘引导启动。需要在安装好的mac上，使用OpencoreConfigure工具，挂载u盘和系统的EFI分区，将u盘的EFI文件复制到系统的EFI分区，注意不要覆盖原有文件。然后重新启动就可以脱离u盘启动。

- 安装win。先在安装好的mac上给硬盘分个区，后面给win安装时选择。
- 使用rufu在win上制作win启动盘。
- 选择u盘启动win启动盘。安装win
- 安装完后只能启动win了，需要在win下用DiskGenius修复mac启动
  - 打开diskgenius，点工具选“设置UEFI BIOS启动项”
  - 点“添加”，在弹出的菜单内选EFI\OC\OpenCore.efi，并上移至第一位
  - 勾选下次启动时直接进入UEFI BIOS设置界面（仅一次）
  - 重启，现在可以用Opencore引导双系统了

win和mac安装顺序是否影响成功
efi文件哪些可行

## 资源
NUC8i5BEH的EFI文件：https://github.com/Jiangmenghao/NUC8i5BEH
修复EFI启动：https://zhuanlan.zhihu.com/p/618721388
修复双系统EFI启动：https://zhuanlan.zhihu.com/p/618721388

## Q&A
- 启动盘无法识别
  - 换个USB接口。显示器的USB接口很可能不行，最好插在主机的USB接口
  - 可能是已经识别，但是时间显示太短。打开EFI/OC/config.plist文件，增加Timeout数值。
  - 可能是没有显示系统列表，直接选择默认系统启动了。打开EFI/OC/config.plist文件，修改ShowPicker为true

- 安装mac时，将分区格式设置了macos日志式，导致无限重启，无法正常安装系统。
试过重新开始制作启动盘再安装不行，一样的界面，显示苹果logo一会就重启了。
用win启动盘，将分区删除就好了（应该只删EFI分区就好，不过我将所有分区都删了）
