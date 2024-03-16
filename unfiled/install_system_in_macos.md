# 在osx下安装系统
## 安装osx
```bash
# 查看可安装系统版本
softwareupdate --list-full-installers
# 安装某个版本系统
softwareupdate --fetch-full-installer --full-installer-version 13.6.3
# 先插入u盘,找到u判断名称,然后执行写入
sudo /Applications/Install\ macOS\ Ventura.app/Contents/Resources/createinstallmedia --volume /Volumes/usb/
```
## 安装linux
先去官网下载iso文件
再插入u盘
```bash
# 搜索对于u盘名字
diskutil list
# 卸载u盘
sudo diskutil unmountDisk /dev/disk4
# 制作启动盘
sudo dd if=/Users/zhou/Downloads/ubuntu-22.04-desktop-amd64+intel-iot.iso of=/dev/disk4
```
