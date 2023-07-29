# vim.api vs vim.fn

它们之前区别是？下面通过源码来分析它们区别。

## lua执行vim.api
观察一个api函数`nvim_buf_get_name`

在neovim源码`nvim_buf_get_name`函数处打断点，执行`lua vim.api.nvim_buf_get_name(0)`，打印堆栈

```c
#1  0x0000561f5d4de7d5 in nlua_api_nvim_buf_get_name (lstate=0x7fdbe00e2380) at ~/code/neovim/build/src/nvim/auto/lua_api_c_bindings.generated.c:1049
#2  0x0000561f5d8e3236 in lj_BC_FUNCC ()
#3  0x0000561f5d8cf4cc in lua_pcall (L=0x7fdbe00e2380, nargs=<optimized out>, nresults=0, errfunc=<optimized out>) at lj_api.c:1116
#4  0x0000561f5d680348 in nlua_pcall (lstate=0x7fdbe00e2380, nargs=0, nresults=0) at ~/code/neovim/src/nvim/lua/executor.c:164
#5  0x0000561f5d683a79 in nlua_typval_exec (lcmd=0x561f5f01ce90 "print(vim.api.nvim_buf_get_name(0))", lcmd_len=35, name=0x561f5d9a7849 ":lua", args=0x0, argcount=0, special=false, ret_tv=0x0) at ~/
code/neovim/src/nvim/lua/executor.c:1453
#6  0x0000561f5d6842d3 in ex_lua (eap=0x7ffe7f2c1ff0) at ~/code/neovim/src/nvim/lua/executor.c:1649
#7  0x0000561f5d612d2a in execute_cmd0 (retv=0x7ffe7f2c1fa8, eap=0x7ffe7f2c1ff0, errormsg=0x7ffe7f2c1fc0, preview=false) at ~/code/neovim/src/nvim/ex_docmd.c:1634
#8  0x0000561f5d614be2 in do_one_cmd (cmdlinep=0x7ffe7f2c2210, flags=0, cstack=0x7ffe7f2c2320, fgetline=0x561f5d62bffc <getexline>, cookie=0x0) at ~/code/neovim/src/nvim/ex_docmd.c:2293
#9  0x0000561f5d61071d in do_cmdline (cmdline=0x0, fgetline=0x561f5d62bffc <getexline>, cookie=0x0, flags=0) at ~/code/neovim/src/nvim/ex_docmd.c:592
#10 0x0000561f5d6e671b in nv_colon (cap=0x7ffe7f2c2980) at ~/code/neovim/src/nvim/normal.c:3244
#11 0x0000561f5d6e2138 in normal_execute (state=0x7ffe7f2c2910, key=58) at ~/code/neovim/src/nvim/normal.c:1202
#12 0x0000561f5d7bce1b in state_enter (s=0x7ffe7f2c2910) at ~/code/neovim/src/nvim/state.c:99
#13 0x0000561f5d6e03c1 in normal_enter (cmdwin=false, noexmode=false) at ~/code/neovim/src/nvim/normal.c:501
#14 0x0000561f5d4d69fb in main (argc=3, argv=0x7ffe7f2c2d28) at ~/code/neovim/src/nvim/main.c:647

```

逐层分析
- main应该是入口函数，normal_enter应该是一个事件循环，监听用户按键。
- normal_execute判断模式，调不同处理方法
- nv_colon处理cmd命令
- 省略部分调用栈分析，直接到execute_cmd0，`build/src/nvim/auto/ex_cmds_defs.generated.h`是命令映射，
根据cmdidx,取出命令进行调用
- 基于上面的map，执行ex_lua
- nlua_typval_exec -> nlua_pcall neovim封装的lua执行方法,然后执行luajit的lua_pcall

最后为什么执行到nlua_api_nvim_buf_get_name？暂时还不是很明白lua的执行机制，先不求甚解。

## vim方式执行vim函数
观察一个vim函数winnr，执行call winnr(0)

源码src/nvim/eval/window.c找到f_winnr，应该就是winnr实际执行的函数。同上打印出堆栈：
```c
#0  f_winnr (argvars=0x7ffe7f2c1c00, rettv=0x7ffe7f2c1db0, fptr=...) at ~/code/neovim/src/nvim/eval/window.c:766
#1  0x0000561f5d5c89b0 in call_internal_func (fname=0x561f5ed772c0 "winnr", argcount=1, argvars=0x7ffe7f2c1c00, rettv=0x7ffe7f2c1db0) at ~/code/neovim/src/nvim/eval/funcs.c:270
#2  0x0000561f5d5ee678 in call_func (funcname=0x561f5ec67130 "winnr", len=5, rettv=0x7ffe7f2c1db0, argcount_in=1, argvars_in=0x7ffe7f2c1c00, funcexe=0x7ffe7f2c1dc0) at ~/code/neovim/src/nvim/eval/us
erfunc.c:1718
#3  0x0000561f5d5eb85b in get_func_tv (name=0x561f5ec67130 "winnr", len=-1, rettv=0x7ffe7f2c1db0, arg=0x7ffe7f2c1e48, evalarg=0x7ffe7f2c1e90, funcexe=0x7ffe7f2c1dc0) at ~/code/neovim/src/nvim/eval/u
serfunc.c:556
#4  0x0000561f5d5f2b56 in ex_call_inner (eap=0x7ffe7f2c1ff0, name=0x561f5ec67130 "winnr", arg=0x7ffe7f2c1e48, startarg=0x561f5ec270da "(0)", funcexe_init=0x7ffe7f2c1eb0, evalarg=0x7ffe7f2c1e90) at ~
/code/neovim/src/nvim/eval/userfunc.c:3159
#5  0x0000561f5d5f358a in ex_call (eap=0x7ffe7f2c1ff0) at ~/code/neovim/src/nvim/eval/userfunc.c:3395
#6  0x0000561f5d612d2a in execute_cmd0 (retv=0x7ffe7f2c1fa8, eap=0x7ffe7f2c1ff0, errormsg=0x7ffe7f2c1fc0, preview=false) at ~/code/neovim/src/nvim/ex_docmd.c:1634
#7  0x0000561f5d614be2 in do_one_cmd (cmdlinep=0x7ffe7f2c2210, flags=0, cstack=0x7ffe7f2c2320, fgetline=0x561f5d62bffc <getexline>, cookie=0x0) at ~/code/neovim/src/nvim/ex_docmd.c:2293
#8  0x0000561f5d61071d in do_cmdline (cmdline=0x0, fgetline=0x561f5d62bffc <getexline>, cookie=0x0, flags=0) at ~/code/neovim/src/nvim/ex_docmd.c:592
#9  0x0000561f5d6e671b in nv_colon (cap=0x7ffe7f2c2980) at ~/code/neovim/src/nvim/normal.c:3244
#10 0x0000561f5d6e2138 in normal_execute (state=0x7ffe7f2c2910, key=58) at ~/code/neovim/src/nvim/normal.c:1202
#11 0x0000561f5d7bce1b in state_enter (s=0x7ffe7f2c2910) at ~/code/neovim/src/nvim/state.c:99
#12 0x0000561f5d6e03c1 in normal_enter (cmdwin=false, noexmode=false) at ~/code/neovim/src/nvim/normal.c:501
#13 0x0000561f5d4d69fb in main (argc=3, argv=0x7ffe7f2c2d28) at ~/code/neovim/src/nvim/main.c:647
```
build/src/nvim/auto/funcs.generated.h call_internal_func会在这里找到要执行的函数。也是一个工具生成的文件

## lua执行vim.fn

同上，执行`lua vim.fn.winnr(0)`
```c
#1  0x0000561f5d5c89b0 in call_internal_func (fname=0x561f5eea36c0 "winnr", argcount=1, argvars=0x7ffe7f2c1c20, rettv=0x7ffe7f2c1bd0) at ~/code/neovim/src/nvim/eval/funcs.c:270
#2  0x0000561f5d5ee678 in call_func (funcname=0x7fdbdff1ac60 "winnr", len=5, rettv=0x7ffe7f2c1bd0, argcount_in=1, argvars_in=0x7ffe7f2c1c20, funcexe=0x7ffe7f2c1be0) at ~/code/neovim/src/nvim/eval/us
erfunc.c:1718
#3  0x0000561f5d683033 in nlua_call (lstate=0x7fdbe00e2380) at ~/code/neovim/src/nvim/lua/executor.c:1183
#4  0x0000561f5d8e3236 in lj_BC_FUNCC ()
#5  0x0000561f5d8cf4cc in lua_pcall (L=0x7fdbe00e2380, nargs=<optimized out>, nresults=0, errfunc=<optimized out>) at lj_api.c:1116
#6  0x0000561f5d680348 in nlua_pcall (lstate=0x7fdbe00e2380, nargs=0, nresults=0) at ~/code/neovim/src/nvim/lua/executor.c:164
#7  0x0000561f5d683a79 in nlua_typval_exec (lcmd=0x561f5ef69500 "vim.fn.winnr(0)", lcmd_len=15, name=0x561f5d9a7849 ":lua", args=0x0, argcount=0, special=false, ret_tv=0x0) at ~/code/neovim/src/nvim
/lua/executor.c:1453
#8  0x0000561f5d6842d3 in ex_lua (eap=0x7ffe7f2c1ff0) at ~/code/neovim/src/nvim/lua/executor.c:1649
#9  0x0000561f5d612d2a in execute_cmd0 (retv=0x7ffe7f2c1fa8, eap=0x7ffe7f2c1ff0, errormsg=0x7ffe7f2c1fc0, preview=false) at ~/code/neovim/src/nvim/ex_docmd.c:1634
#10 0x0000561f5d614be2 in do_one_cmd (cmdlinep=0x7ffe7f2c2210, flags=0, cstack=0x7ffe7f2c2320, fgetline=0x561f5d62bffc <getexline>, cookie=0x0) at ~/code/neovim/src/nvim/ex_docmd.c:2293
#11 0x0000561f5d61071d in do_cmdline (cmdline=0x0, fgetline=0x561f5d62bffc <getexline>, cookie=0x0, flags=0) at ~/code/neovim/src/nvim/ex_docmd.c:592
#12 0x0000561f5d6e671b in nv_colon (cap=0x7ffe7f2c2980) at ~/code/neovim/src/nvim/normal.c:3244
#13 0x0000561f5d6e2138 in normal_execute (state=0x7ffe7f2c2910, key=58) at ~/code/neovim/src/nvim/normal.c:1202
#14 0x0000561f5d7bce1b in state_enter (s=0x7ffe7f2c2910) at ~/code/neovim/src/nvim/state.c:99
#15 0x0000561f5d6e03c1 in normal_enter (cmdwin=false, noexmode=false) at ~/code/neovim/src/nvim/normal.c:501
#16 0x0000561f5d4d69fb in main (argc=3, argv=0x7ffe7f2c2d28) at ~/code/neovim/src/nvim/main.c:647
```
因为是通过lua执行，所以也会走lua执行函数。

## 总结
- nvim有个事件循环，时刻监听用户按键。
- 无论是执行vim旧函数还是nvim的api，都会通过先执行cmdline的方法，因为它们都是cmd命令。
- vim旧函数执行，会在一个工具生成的文件里找到对应函数，然后执行。
- vim的api有一个lua executor，通过lua api执行函数。
- lua里执行vim.fn，会先走lua executor，再走旧函数的执行。
- 其实除了执行流程，它们机会没有区别，都是c代码。

后续可以研究：
- 怎么生成nvim的api和vim旧方法的？
- cmd怎么判断执行lua还是vim call，还有其他命令？
- lua执行机制
