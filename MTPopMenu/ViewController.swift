//
//  ViewController.swift
//  MTPopMenu
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let menu = MTPopMenu.sharedPopMenu()
    // 这里用元祖记录（选中index, 标题）
    // 当然也可以用别的方式去记录你自己选中的index，再传给MTPopMenu
    var titleArray = [(0, ["第一个按钮", "啦啦啦"]), (0, ["第二个按钮", "呵呵呵呵", "汪汪汪汪"]), (0, ["第三个按钮", "大大大"])]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for (index, _) in self.titleArray.enumerated() {
            let btn = UIButton(frame: CGRect.init(x: 50 + 100 * index, y: 100, width: 50, height: 30))
            btn.backgroundColor = .red
            btn.addTarget(self, action: #selector(showMenu(btn:)), for: .touchUpInside)
            btn.tag = index
            self.view.addSubview(btn)
        }
    }

    @objc func showMenu(btn: UIButton) {
        
        var tump = titleArray[btn.tag]
        
        menu.popMenu(anchorView: btn, titleArray: tump.1)
        menu.selectTextColor = .green // 选中字体颜色
        menu.normalTextColor = .yellow // 默认颜色
        menu.menuBgColor = .lightGray // table背景色
        menu.selectIndex = tump.0
        
        menu.didSelectItem = { (index, model) in
            tump.0 = index
            self.titleArray[btn.tag] = tump
            // TODO 选中处理
        }
    }
}

