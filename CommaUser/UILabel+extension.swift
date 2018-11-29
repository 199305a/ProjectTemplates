//
//  UILabel+extension.swift
//  CommaBinder
//
//  Created by yuanchao on 2017/9/26.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

extension UILabel {
    
    func showSpecialColor(_ color: UIColor, pattern: String) {
        let txt = text ?? ""
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let resultArr = regex.matches(in: txt, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, txt.count))
            let attributedStr = NSMutableAttributedString(string: txt, attributes: [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: font])
            resultArr.forEach({ (res) in
                attributedStr.setAttributes([NSAttributedStringKey.foregroundColor: color], range: res.range)
            })
            attributedText = attributedStr
        } catch {
           dLog(error.localizedDescription)
        }
    }
}

extension UILabel {
    func show(_ msg: String = "", duration: TimeInterval = 2) {
        text = msg
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+duration) {
            self.isHidden = true
        }
    }
    
    //MARK: 设置属性: 行间距,属性字体大小,颜色
    func setAttribute(lineSpacing: CGFloat, font: UIFont, textColor: UIColor, text: String) {
        let attributeText: NSMutableAttributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributeText.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.length))
        attributeText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.length))
        attributeText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.length))
        
        self.attributedText = attributeText
    }

}

