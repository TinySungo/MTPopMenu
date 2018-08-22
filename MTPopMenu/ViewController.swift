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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton(frame: CGRect.init(x: 100, y: 100, width: 30, height: 30))
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(showMenu(btn:)), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let btn1 = UIButton(frame: CGRect.init(x: 200, y: 200, width: 30, height: 30))
        btn1.backgroundColor = .red
        btn1.addTarget(self, action: #selector(showMenu(btn:)), for: .touchUpInside)
        self.view.addSubview(btn1)
    }

    @objc func showMenu(btn: UIButton) {
        menu.popMenu(anchorView: btn, titleArray: ["全部", "哈哈哈", "啦啦啦啦啦啦", "哒哒哒哒哒"])
        menu.selectTextColor = .green // 选中字体颜色
        menu.menuBgColor = .lightGray // table背景色
        
        menu.didSelectItem = { (index, model) in
            print(index, model)
        }
    }
}

