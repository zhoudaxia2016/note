# treesitter indent

## 前置知识
可以用正则做类比。
正则是对字符串进行匹配，并且可以对匹配的字符串进行分组并命名
对于一颗语法树，我们也可以通过某种语法（query），对节点进行捕获分组命名，这就是capture
nvim treesitter indent的实现，有这几种捕获分组：
```
@indent         ; Indent children when matching this node
@indent_end     ; Marks the end of indented block
@aligned_indent ; Behaves like python aligned/hanging indent
@dedent         ; Dedent children when matching this node
@branch         ; Dedent itself when matching this node
@ignore         ; Do not indent in this node
@auto           ; Behaves like 'autoindent' buffer option
@zero_indent    ; Sets this node at position 0 (no indent)
```

## nvim实现

1. 通过遍历当前行开头的节点的parent，如果是在indent里，则indent++
  例子：代码如下
  ```
  function a() {
    if (true) {
      // cursor here
    }
  }
  ```
  从cursor节点到root的路径为：
  cursor -> statement_block -> if_statement -> statement_block -> function_decoration
  在indent里是指iter_captures捕获到了indent的分组，
  有两个statement_block是indent分组的，所以缩进就是2 * indentsize
  直观来说，statement_block就是指{}，{}里的代码都要缩进一层
2. indent_end分组。当我们新增一个空行时，需要看前一行最后的节点：
  - 若是indent_end则获取parent
  - 否则取上一行最后一个节点，和它一样的缩进
3. branch && dedent分组。有些子节点和父节点的缩进是一样的，所以加个branch分组，让它先减1，到它的父节点时，再加1的话，相当于缩进不变，与父节点一样。

- [ ] abc
- [ ] def
  sadsad s
- [ ] haha
- [ ] haha
- [ ] haha
- [ ] haha
- [ ] haha
