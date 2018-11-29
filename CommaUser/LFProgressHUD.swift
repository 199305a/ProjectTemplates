//
//  LFProgressHUD.swift
//  LikingManager
//
//  Created by Marco Sun on 16/9/27.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import MBProgressHUD

class LFProgressHUD: NSObject {
    
    fileprivate enum Style {
        case info
        case success
        case error
        case none
    }
    
    static var duration: TimeInterval = 1.5
    static var delay: TimeInterval = 0.3
    
    // show hud in view
    
    @discardableResult
    class func showLoading(_ view: UIView) -> MBProgressHUD {
        hideHUDs(view)
        return LFMProgressHUD.showAdded(to: view, animated: true)
    }
    
    @discardableResult
    class func dismiss(_ view: UIView, complete: EmptyClosure? = nil) -> Bool {
        if let complete = complete {
            GlobalAction.delayPerformOnMainQueue(delay, task: complete)
        }
        return LFMProgressHUD.hide(for: view, animated: true)
    }
    
    @discardableResult
    class func showNetErrorMessage(_ view: UIView) -> MBProgressHUD {
        return showTextMessage(view, message: Text.NetErrorMessage)
    }
    
    @discardableResult
    class func showServerErrorMessage(_ view: UIView) -> MBProgressHUD {
        return showTextMessage(view, message: Text.ServerErrorMessage)
    }
    
    class func showClickedNetErrorMessage(_ view: UIView) {
        LFMProgressHUD.hide(for: view, animated: false)
        LFAlertView.showClickNetworkError()
        
    }
    
    @discardableResult
    class func showWithMessage(_ view: UIView, message: String?) -> MBProgressHUD {
        hideHUDs(view)
        let hud = LFMProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = String.isNotEmptyString(message) ? message : Text.MsgDefault
        hud.label.textColor = UIColor.white
        return hud
    }
    
    @discardableResult
    class func showInfoWithMessage(_ view: UIView, message: String?) -> MBProgressHUD {
        return showStatusWithMessage(view, message: message, status: .info)
    }
    
    @discardableResult
    class func showErrorWithMessage(_ view: UIView, message: String?) -> MBProgressHUD {
        return showStatusWithMessage(view, message: message, status: .error)
    }
    
    @discardableResult
    class func showSuccessWithMessage(_ view: UIView, message: String?) -> MBProgressHUD {
        return showStatusWithMessage(view, message: message, status: .success)
    }
    
    @discardableResult
    class func showTextMessage(_ view: UIView, message: String?) -> MBProgressHUD {
        return showStatusWithMessage(view, message: message, status: .none)
    }
    
    @discardableResult
    fileprivate class func showStatusWithMessage(_ view: UIView, message: String?, status: LFProgressHUD.Style) -> MBProgressHUD {
        hideHUDs(view)
        let hud = LFMProgressHUD.showAdded(to: view, animated: true)
        var image: UIImage?
        var defaultMessage = " "
        switch status {
        case .info:
            image = UIImage.init(named: "hud_message")
        case .error:
            image = UIImage.init(named: "hud_error")
            defaultMessage = Text.MsgError
        case .success:
            image = UIImage.init(named: "hud_right")
            defaultMessage = Text.MsgSuccess
        case .none:
            break
        }
        if image != nil {
            hud.customView = UIImageView.init(image: image)
        }
        hud.mode = image == nil ? .text : .customView
        hud.animationType = .zoom
        if hud.mode == .text {
            hud.margin = 15
        } 
        setMessageAndHide(hud, message: String.isNotEmptyString(message) ? message : defaultMessage)
        return hud
    }
    
    
    
    class func setMessageAndHide(_ hud: MBProgressHUD, message: String?) {
        hud.label.font = UIFont.bold15
        hud.label.text = message
        hud.label.textColor = UIColor.white
        hud.hide(animated: true, afterDelay: duration)
    }
    
    class func hideHUDs(_ view: UIView) {
        let arr = view.subviews.filter { (v) -> Bool in
            v is MBProgressHUD
        }
        if arr.count == 1 {
            let h = arr.first as! MBProgressHUD
            h.hide(animated: true, afterDelay: delay)
            Thread.sleep(forTimeInterval: delay)
        } else {
            arr.forEach({ (v) in
                let h = v as! MBProgressHUD
                h.hide(animated: false)
            })
        }
    }
    
    class func hideOtherHUDs(_ hud: MBProgressHUD, view: UIView) {
        view.subviews.forEach { (v) in
            if v is MBProgressHUD && v !== hud {
                (v as! MBProgressHUD).hide(animated: false)
            }
        }
    }
    
    @discardableResult
    // show hud in some hud's superview
    class func showLoading(hud: MBProgressHUD?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showLoading(view)
    }
    
    @discardableResult
    class func dismiss(hud: MBProgressHUD?) -> Bool {
        guard let view = hud?.superview else { return false }
        return dismiss(view)
    }
    
    @discardableResult
    class func showNetErrorMessage(hud: MBProgressHUD?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showNetErrorMessage(view)
    }
    
    @discardableResult
    class func showServerErrorMessage(hud: MBProgressHUD?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showServerErrorMessage(view)
    }
    
    class func showClickedNetErrorMessage(hud: MBProgressHUD?) {
        guard let view = hud?.superview else { return }
        showClickedNetErrorMessage(view)
    }
    
    @discardableResult
    class func showWithMessage(hud: MBProgressHUD?, message: String?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showErrorWithMessage(view, message: message)
    }
    
    @discardableResult
    class func showInfoWithMessage(hud: MBProgressHUD?, message: String?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showInfoWithMessage(view, message: message)
    }
    
    @discardableResult
    class func showErrorWithMessage(hud: MBProgressHUD?, message: String?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showErrorWithMessage(view, message: message)
    }
    
    @discardableResult
    class func showSuccessWithMessage(hud: MBProgressHUD?, message: String?) -> MBProgressHUD? {
        guard let view = hud?.superview else { return nil }
        return showSuccessWithMessage(view, message: message)
    }
    
}

class LFMProgressHUD: MBProgressHUD {
    
    override init(view: UIView) {
        super.init(view: view)
        customizeInterface()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customizeInterface() {
        layer.zPosition = ViewPostion.ProgressHUD
        removeFromSuperViewOnHide = true
        label.numberOfLines = 0
        minShowTime = 0.5
        animationType = .zoomOut
        bezelView.style = .solidColor
        bezelView.color = UIColor.hexColor(0x515360).withAlphaComponent(0.89)
        contentColor = UIColor.white        
    }
}

