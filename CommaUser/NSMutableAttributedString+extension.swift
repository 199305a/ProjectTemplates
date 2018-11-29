//
//  NSMutableAttributedString+extension.swift
//  CommaUser
//
//  Created by macbook on 2018/10/24.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

import UIKit
public enum KVAttributedInsertType : Int {
    
    case First
    case last
}

extension NSMutableAttributedString {
    ///文本前后插入图片
    convenience init(imageName: String,contentString: String ,attributedInsertType: (KVAttributedInsertType),label: UILabel){
        self.init()
        let att = NSAttributedString(string: contentString)
        self.append(att)
        //根据附件生成富文本
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named:imageName)
        //        //设置（图片）字体大小
        //调节图片的大小
        attachment.bounds = CGRectMake(5, 0, 9, 11)
        let attString = NSAttributedString(attachment: attachment)
        if attributedInsertType == .First {
            self.insert(attString, at: 0)
        } else {
            self.insert(attString, at: (contentString as NSString).length)
        }
    }

}
