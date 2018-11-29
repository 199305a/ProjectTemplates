//
//  TagsView.swift
//  CommaUser
//
//  Created by user on 2018/11/8.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class TagsView: BaseView {

    public var tagtop: CGFloat = 0.0
    public var leading: CGFloat = 0.0
    public var trailing: CGFloat = 0.0
    public var bottomH: CGFloat = 0.0
    public var ySpacing: CGFloat = 8
    public var xSpacing: CGFloat = 8.0
    public var heightTag: CGFloat = 0
    
    lazy var heighConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        constraint.isActive = true
        return constraint }()
    
    var tags = [TagLabel]() {
        didSet { oldValue.forEach { $0.removeFromSuperview() } }
    }
    
    
    private func createTagWithTitle(_ title: String,
                                    _ font: UIFont,
                                    _ textColor: UIColor, _ fontInset: CGFloat,
                                    _ cornerRadius: CGFloat,
                                    _ bgColor: UIColor?) -> TagLabel {
        let tag = TagLabel()
        tag.text = title
        tag.setUp(textColor: textColor, font: font)
        tag.sizeToFit()
        tag.frame.size.height = (font.pointSize) + fontInset
        
        if cornerRadius != 0 {
            tag.layer.cornerRadius = cornerRadius
            tag.clipsToBounds = true
        }
        
        if bgColor != nil {
            tag.backgroundColor = bgColor
        } else {
            tag.backgroundColor = self.backgroundColor
        }
        
        addSubview(tag)
        return tag
    }
    
    public func createTagsWithTitles(titles: [String],
                                          font: UIFont,
                                          textColor: UIColor,
                                          fontInset: CGFloat,
                                          cornerRadius: CGFloat = 0,
                                          bgColor: UIColor? = nil) {
        tags = titles.map { createTagWithTitle($0, font, textColor, fontInset, cornerRadius, bgColor) }
        layoutIfNeeded()
    }
    
    // MARK: - Layout tabButtons
    public override func layoutSubviews() {
        super.layoutSubviews()
        arrangeTagButton()
    }
    
    private func arrangeTagButton() {
        let maxViewWidth = self.frame.width
        var offset = CGPoint(x: leading, y: tagtop)
        self.tags.forEach { self.layoutTag($0, maxViewWidth, &offset) }
        self.heighConstraint.constant =  offset.y + heightTag + self.bottomH
    }
    
    private func layoutTag(_ tag: TagLabel, _ maxViewWidth: CGFloat, _ offset: inout CGPoint) {
        let widthTagButton = tag.frame.width
        if (offset.x + widthTagButton + trailing) > maxViewWidth {
            offset.x = leading
            offset.y += heightTag + ySpacing
        }
        tag.frame.origin = offset
        offset.x += widthTagButton + xSpacing
    }
    
}

class TagLabel: BaseLabel {
    
}
