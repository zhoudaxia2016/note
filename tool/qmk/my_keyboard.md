# 客制化键盘keymap配置备忘
pcb: DZ60V2

## 资源链接
- 刷固件代码：https://github.com/qmk/qmk_firmware
- 刷固件软件：https://github.com/qmk/qmk_toolbox/releases/download/0.2.2/qmk_toolbox.exe
- 装驱动（应该不需要）：https://zadig.akeo.ie
- qmk文档：https://docs.qmk.fm/#/

这个也是刷固件的工具(更加方便，图形化)，但是一直无法识别键盘。

via: https://usevia.app/

## 步骤
1. 安装`qmktoolbox`（刷固件软件）

https://github.com/qmk/qmk_toolbox/releases/download/0.2.2/qmk_toolbox_install.exe
注意是旧版本的。不知道为啥新版本可以识别键盘，但是刷不进去。

2. qmktoolbox -> tools -> install drivers

安装驱动

3. `clone` `qmk`仓库

已`fork`，git@github.com:zhoudaxia2016/qmk_firmware.git

4. `qmk`库，安装`submodule`

`git submodule update --init --recursive --progress --depth=1`

5. 安装`qmk`（应该也可以不装，直接用`make`）

`python3 -m pip install --user qmk`
安装`qmk`的依赖等
`qmk setup`

6. 在`qmk`仓库找到`DZ60V2`配置代码，构建

DZ60V2是在 keyboards/dztech/dz60v2/keymaps/default/
所以执行：
`qmk compile -kb dztech/dz60v2 -km default`

7. 用`qmktoolbox`刷固件

键盘先进入`bootloader`模式：
可以按键盘pcd背面的按钮，或者按住`esc`，再插线。
另外，也可以单独设置一个按键进入`bootloader`，按键名字是`QK_BOOTLOADER`
进入`bootloader`后，`qmktoolbox`会显示connected
然后在`qmktoolbox`选择上一步构建生成的`hex`文件，按`flash`

大功告成

## 具体keymap改动
- capslock改成ctrl
- 按住F，然后按vim方向键（hjkl），作为方向键。用LT(layer, key)实现
LT含义：按住key则打开layer层，tap则触发key
- 分裂的第三个空格作为Fn键
- 右shift的右边的key切换mac和win。mac和win不同
  - win: 左下是win，alt
  - mac: 相同位置是option，command
  切换系统时按一下这个key，就会切换上面两个键

## faq
- 改了keymap文件，刷固件不生效
https://docs.qmk.fm/#/faq_keymap?id=my-keymap-doesnt-update-when-i-flash-it
