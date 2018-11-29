//
//  UITextView+extension.swift
//  CommaUser
//
//  Created by user on 2018/11/8.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import Foundation

extension UITextView {
    //MARK: 设置属性: 行间距,属性字体大小,颜色
    func setAttribute(lineSpacing: CGFloat, font: UIFont, textColor: UIColor, text: String = "") {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attributes = [NSAttributedStringKey.font.rawValue : font, NSAttributedStringKey.paragraphStyle.rawValue : paragraphStyle, NSAttributedStringKey.foregroundColor.rawValue : textColor]
        self.typingAttributes = attributes
        self.text = text
    }

}
