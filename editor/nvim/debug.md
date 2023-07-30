# debug neovim笔记

## nvim_buf_get_name
文件: `src/nvim/api/buffer.c`
```c
String nvim_buf_get_name(Buffer buffer, Arena *arena, Error *err)
  FUNC_API_SINCE(1)
{
  String rv = STRING_INIT;
  buf_T *buf = find_buffer_by_handle(buffer, err);

  if (!buf || buf->b_ffname == NULL) {
    return rv;
  }

  return cstr_as_string(buf->b_ffname);
}
```
- Buffer是什么类型？定义如下:
```c
typedef int handle_T; // 定义int别名handle_T
#define REMOTE_TYPE(type) typedef handle_T type // 定义一个宏方便将定义类型为handle_T
REMOTE_TYPE(Buffer); // 定义Buffer为handle_T
```
Buffer其实就是个int
另外，也可以同gdb命令[^ptype]查看Buffer类型

- 当buffer为0，则返回当前buffer
```c
EXTERN buf_T *curbuf INIT(= NULL)
```
当前buffer指针是存在`src/nvim/globals.h`文件里的，
疑问:
- `curbuf`用来INIT宏来初始化，但是用了`extern`关键字。为什么
extern可以初始化？

`display *rv`可以查看struct属性


[^ptype]: gdb命令，打印类型别名代表的类型
[^typedef]: c关键字，定义类型别名

