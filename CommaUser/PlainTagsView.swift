//
//  PlainTagsView.swift
//  CommaUser
//
//  Created by user on 2018/11/20.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class PlainTagsView: UIView {
    
    //MARK: 创建 tags
    func createTags(titles: [String], tags: [String : [String]]) -> CGFloat {
        let ySpacing: CGFloat = 15
        var allHeight: CGFloat = 0
        
        for (i, title) in titles.enumerated() {
            let tagView = PlainTagView()
            self.addSubview(tagView)
            
            if i > 0 {
                allHeight += ySpacing * CGFloat(i)
            }
            
            tagView.snp.makeConstraints { (make) in
                make.top.equalTo(allHeight)
                make.left.right.equalTo(0)
                make.height.equalTo(44)
            }
            
            let tempHeight: CGFloat = tagView.setTag(title: title, tags: tags[title] ?? [])
            
            tagView.snp.remakeConstraints { (make) in
                make.top.equalTo(allHeight)
                make.left.right.equalTo(0)
                make.height.equalTo(tempHeight)
            }
            
            allHeight += tempHeight
        }
        
        return allHeight
    }
}

class PlainTagView: BaseView {
    let tagView = TagsView()
    let titleLabel = BaseLabel()
    
    override func customizeInterface() {
        self.backgroundColor = UIColor.hxf7f7f7
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.hx129faa.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.1
        
        titleLabel.setUp(textColor: UIColor.hx5c5e6b, font: UIFont.bold15)
        tagView.backgroundColor = UIColor.hxf7f7f7
        tagView.leading = 15
        tagView.trailing = 10
        tagView.xSpacing = 15
        tagView.ySpacing = 10
        tagView.tagtop = 10
        tagView.bottomH = 0
        tagView.heightTag = 21
        
        self.addSubview(titleLabel)
        self.addSubview(tagView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.height.equalTo(21)
        }
        
        tagView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-12)
        }
    }
    //MARK: 设置 cell
    func setTag(title: String, tags: [String]) -> CGFloat {
        titleLabel.text = title
        tagView.createTagsWithTitles(titles: tags, font: UIFont.bold15, textColor: UIColor.hx5c5e6b, fontInset: 5)
        return (43 + tagView.heighConstraint.constant)
    }
    
}
