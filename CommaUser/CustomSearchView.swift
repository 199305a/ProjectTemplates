//
//  CustomSearchView.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/28.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

//自定义的搜索视图

class CustomSearchView: UIView,UISearchBarDelegate {
    
    var obscuresBackgroundView: UIView!
    var isActive: Bool = false
    var updateSearchResults: ((CustomSearchView)->Void)?
    weak var ownerVC: UIViewController?
    var searchBar: UISearchBar!
    var isHidSystemBorder = false
    var textFieldHeight: CGFloat = 28
    var cancelBtn = UIButton()
    var originBounds = CGRect.zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBar = UISearchBar(frame: self.bounds)
        searchBar.delegate = self
        obscuresBackgroundView = UIView.init(frame: UIScreen.main.bounds)
        addSubview(searchBar)
        obscuresBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        obscuresBackgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(slideDown)))
        originBounds = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        slideUp()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        slideDown()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            showObscuresBackgroundView()
        } else {
            self.obscuresBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.obscuresBackgroundView.removeFromSuperview()
        }
        updateSearchResults?(self)
        
    }
    
    func slideUp() {
        
        searchBar.becomeFirstResponder()
        if isActive { return }
        showObscuresBackgroundView()
        searchBar.setShowsCancelButton(true, animated: true)
        
        let btn = searchBar.value(forKey: "cancelButton") as! UIButton
        btn.setTitle(cancelBtn.currentTitle, for: .normal)
        btn.setTitleColor(cancelBtn.currentTitleColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: cancelBtn.titleLabel?.font.pointSize ?? 15)
        cancelBtn = btn
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration), animations: {
//            self.frame.size.height += 20
//            self.searchBar.frame.origin.y += 20
            self.obscuresBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }) { flag in
            self.updateSearchResults?(self)
            self.isActive = true
        }
//        ownerVC?.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func slideDown() {
        if !isActive { return }
        
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration), animations: {
//            self.frame.size.height -= 20
//            self.searchBar.frame.origin.y -= 20
            self.obscuresBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (flag) in
            self.isActive = false
            self.obscuresBackgroundView.removeFromSuperview()
            self.updateSearchResults?(self)
        }
//        ownerVC?.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
    
    override func layoutSubviews() {
        searchBar.subviews.first?.subviews.forEach({ (v) in
            if v.classForCoder == NSClassFromString("UISearchBarBackground") {
                v.alpha = isHidSystemBorder ? 0 : 1
            } else if v is UITextField {
                DispatchQueue.main.async {
                    v.backgroundColor = UIColor.hxc1c3c8.withAlphaComponent(0.18)
                    v.layer.cornerRadius = 4
                    v.layer.masksToBounds = true
                    v.frame.size.height = self.textFieldHeight
                    v.frame.origin.y = (self.originBounds.height - self.textFieldHeight) / 2
                }
            }
        })
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            return
        }
        
        ownerVC = newSuperview!.controller()
    }
    
    func showObscuresBackgroundView() {
        guard let vc = ownerVC else {
            return
        }
        if obscuresBackgroundView.superview == nil {
            vc.view.addSubview(obscuresBackgroundView)
            obscuresBackgroundView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.bottom)
                make.left.right.bottom.equalTo(vc.view)
            }
        }
        obscuresBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
}
