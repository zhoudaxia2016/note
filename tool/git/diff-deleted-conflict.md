# diff deleted conflict

## 场景

使用merge出现冲突时，可能会出现当前分支文件被删而目标分支的这个文件有改动的情况。
我们想看看最新的修改是什么，然后再做如何解决冲突的决定。
git的mergetool并没有该功能。

## 方法

```
# when deleted by us
git diff ...incoming_merge_branch -- rel_path_deleted_file
# when deleted by theirs
git diff incoming_merge_branch... -- rel_path_deleted_file
```

参考[Better diff for deleted file merge conflict](https://github.com/microsoft/vscode/issues/88973)

diff命令也可以换成difftool，直接用编辑器查看，会更清晰

## 解释

[what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif](https://stackoverflow.com/questions/7251477/what-are-the-differences-between-double-dot-and-triple-dot-in-git-dif)
补充解释
[what-are-the-differences-between-double-dot-and-triple-dot-in-git-com](https://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com)
简单来说，...左右两边分别是commit或者分支（分支也是指向某个commit）,也可以省略其中一个，省略则表示是HEAD
命令返回右边commit和它们merge-base的diff

(下面说的是第一种情况，deleted by us)
其实和我们想要的东西是一样的，我们想diff和目标分支最近的merge commit之后，目标分支对该文本的新增改动，以便我们更好决定如何处置这个文件。

## 扩展

有时我们是多人协作一起开发，冲突需求多人各自解决，我们会先暂时先胡乱（将冲突提交）合并，然后分配其他开发各自进行解决自己的冲突。
这样我们不能通过上面的命令来diff了，因为结果肯定为空(我们已经merge了，merge-base肯定已经包含目标分支的commit)

我们可以找到merge的那个commit，找到merge的两个commit，它们即是我们merge时的两个commit，可以替代上面命令的两个分支。
