//
//  MTPopMenu.swift
//  MTPopMenu
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import UIKit

public class MTPopMenu: UIView {
    
    // menu视图
    static let menu = MTPopMenu(frame: .zero)
    // 标题数组
    var titleArray: [String]?
    // 图片文字的对象数组
    var menuArray = [MTPopMenuModel]() {
        didSet {
            refreshUI()
        }
    }
    // 宽度
    var tableWidth: CGFloat = 0
    // anchorView相对于window的位置
    var anchorRect = CGRect.zero
    // 展示列表的table
    lazy var table: UITableView = {
        let tempTableView = UITableView (frame: .zero, style: .plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = self.menuBgColor
        tempTableView.separatorStyle = .none
        tempTableView.layer.cornerRadius = self.cornerRadius
        tempTableView.clipsToBounds = true
        tempTableView.register(MTPopMenuTableViewCell.self, forCellReuseIdentifier: "MTPopMenuTableViewCell")
        tempTableView.isScrollEnabled = false
        return tempTableView
    }()
    
    
    // 一行的高度
    public var menuCellHeight : CGFloat = 50.0
    // 最多展示的行数，当大于这个行数时，高度不变，可滑动
    public var menuMaxRow = 5
    // 背景色
    public var menuBgColor = UIColor.gray {
        didSet {
            self.table.backgroundColor = menuBgColor
        }
    }
    // 圆角
    public var cornerRadius : CGFloat = 5.0 {
        didSet {
            self.table.layer.cornerRadius = cornerRadius
        }
    }
    // 文字大小
    var titleFont = UIFont.systemFont(ofSize: 14)
    // cell两边的间距
    public var menuCellPadding: CGFloat = 20.0
    // 选中第几个
    public var selectIndex = 0 {
        didSet {
            updateSelectedModel()
        }
    }
    // 默认的文字颜色
    public var normalTextColor = UIColor.white {
        didSet {
            self.table.reloadData()
        }
    }
    // 选中的文字颜色
    public var selectTextColor = UIColor.blue {
        didSet {
            self.table.reloadData()
        }
    }
    // 选择的回调
    public typealias closureBlock = (Int, MTPopMenuModel) -> Void
    public var didSelectItem: closureBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.table)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 更新视图
    func refreshUI() {
        self.table.removeFromSuperview()
        self.addSubview(self.table)
        calculateWidth()
        updateFrame()
        self.table.reloadData()
    }
    
    // 设置选中的model
    func updateSelectedModel() {
        for (index, item) in self.menuArray.enumerated() {
            var model = item
            model.selected = (index == selectIndex)
            self.menuArray[index] = model
        }
        self.table.reloadData()
    }
    
    // 更新frame
    func updateFrame() {
        // 设置frame
        let X = self.anchorRect.size.width / 2.0 + self.anchorRect.origin.x - self.tableWidth / 2.0
        var frame = CGRect.init(x: X, y: self.anchorRect.maxY + 20, width: self.tableWidth, height: 0)
        
        self.table.frame = frame
        frame.size.height = CGFloat(self.menuArray.count) * self.menuCellHeight
        
        UIView.animate(withDuration: 0.25) {
            self.table.frame = frame
        }
    }
    
    // 计算宽度
    func calculateWidth() {
        for model in self.menuArray {
            
            let rect = NSString(string: model.title!).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 20), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.titleFont], context: nil)
            self.tableWidth = max(self.tableWidth, rect.width + self.menuCellPadding * 2.0)
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    // dismiss
    func dismiss() {
        var rect = self.table.frame
        rect.size.height = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.table.frame = rect
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

public extension MTPopMenu {
    static func sharedPopMenu() -> MTPopMenu {
        return self.menu
    }
    
    public func popMenu(anchorView: UIView, menuArray: [MTPopMenuModel]) {
        let window = UIApplication.shared.delegate?.window!
        self.frame = (window?.bounds)!
        window?.addSubview(self)
        
        self.anchorRect = anchorView.convert(anchorView.bounds, to: window)
        self.menuArray = menuArray
        self.updateSelectedModel()
    }
    
    func popMenu(anchorView: UIView, titleArray: [String]) {
        var models = [MTPopMenuModel]()
        for title in titleArray {
            var model = MTPopMenuModel()
            model.title = title
            models.append(model)
        }
        return self.popMenu(anchorView: anchorView, menuArray: models)
    }
}


extension MTPopMenu : UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.menuCellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MTPopMenuTableViewCell", for: indexPath) as! MTPopMenuTableViewCell
        
        cell.backgroundColor = self.menuBgColor
        cell.loadCell(model: self.menuArray[indexPath.row],
                      size: CGSize(width: self.tableWidth, height: self.menuCellHeight),
                      font: self.titleFont,
                      highlightColor: self.selectTextColor,
                      normalColor: self.normalTextColor)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row

        if self.didSelectItem != nil {
            self.didSelectItem!(indexPath.row, menuArray[indexPath.row])
        }
        
        dismiss()
    }
}
