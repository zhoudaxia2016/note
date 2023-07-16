# 调试代码技巧

- 提供最小复现场景
- 对比成功和失败时区别

## 调试chrome extensions

- Undock chrome devtool，then ctrl-shfit-i open devtools's devtool
- 调试background.js，打开插件管理，找到对应插件，有入口能跳到backgroud

## 调试开了子进程或者多进程的程序

### node child_process模块
给子进程添加inspect参数
```
child_process.fork('node', {execArgv: ['--inspect-brk', '2.js']})
child_process.exec('node --inspect-brk 2.js')
child_process.spawn('node', ['--inspect-brk', '2.js'])
```

### jest-worker

jest-worker的实现有两种：
- child_process
- worker_threads

两种情况都需要`在调用jest-worker的地方传numWorkers=1`

child_process，即调用jest-worker时传enableWorkerThreads=false
- 在jest-worker里的ChildProcessWorker的调用child_process.folk的地方传--inspect-brk参数

worker_threads，即调用jest-worker时传enableWorkerThreads=true
- 在子线程入口即jest-worker里的threadChild加入以下代码
```
const inspector = require("node:inspector")
inspector.open()
inspector.waitForDebugger()

```

:chrome:node:debug:
