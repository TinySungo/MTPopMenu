//
//  MTPopMenuTableViewCell.swift
//  MTPopMenu
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

import UIKit

class MTPopMenuTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
        
        self.addSubview(self.titleLabel)
        self.titleLabel.frame = self.bounds
    }

    func loadCell(model: MTPopMenuModel, size: CGSize, font: UIFont, highlightColor: UIColor) {
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.titleLabel.font = font
        self.titleLabel.text = model.title
        self.titleLabel.highlightedTextColor = highlightColor

        if model.selected {
            self.titleLabel.textColor = highlightColor
        }
        else {
            self.titleLabel.textColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
