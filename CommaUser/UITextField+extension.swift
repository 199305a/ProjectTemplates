//
//  UITextField+extension.swift
//  CommaUser
//
//  Created by lekuai on 2017/7/12.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITextField {

    //MARK: - 控制输入长度
    func controlTextLength(len: Int, disposeBag: DisposeBag) {
        NotificationCenter.default.rx.notification(NSNotification.Name.UITextFieldTextDidChange, object: self).bind { [unowned self] _ in
            guard let text = self.text else {
                return
            }
            if (text.count > len) {
                let tx = String(text[..<text.index(text.startIndex, offsetBy: len)])
                self.text = tx
            }
        }.disposed(by: disposeBag)
    }
}


