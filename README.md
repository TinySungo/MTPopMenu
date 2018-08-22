# MTPopMenu
相对于一个视图的下拉菜单，类似微信右上角的➕按钮

# How to use

```
let menu = MTPopMenu.sharedPopMenu()
menu.popMenu(anchorView: btn, titleArray: ["全部", "哈哈哈", "啦啦啦啦啦啦", "哒哒哒哒哒"])
menu.selectTextColor = .green // 选中字体颜色
menu.menuBgColor = .lightGray // table背景色
menu.didSelectItem = { (index, model) in
print(index, model)
}

```
