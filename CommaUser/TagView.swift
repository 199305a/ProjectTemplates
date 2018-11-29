//
//  TagView.swift
//  TagView
//
//  Created by pulsar on 12.08.17.
//  Copyright © 2017 pulsar. All rights reserved.
//

import UIKit
import RxSwift

public class TagView: UIView {
  public var tagtop: CGFloat = 0.0
  public var leading: CGFloat = 0.0
  public var trailing: CGFloat = 0.0
  public var buttom: CGFloat = 0.0
  public var ySpacing: CGFloat = 8
  public var xSpacing: CGFloat = 8.0
  public var hiddeSection: Bool = true

 var btnClick:((TagButton) -> ())?
    
lazy var disposeBag: DisposeBag! = DisposeBag()

  private var editTagButton: (TagButton?, top: Bool) = (nil, false) {
    didSet {
      guard let tagButton = oldValue.0 else { return }
      tagButton.removeFromSuperview()
    }
  }
  private lazy var heighConstraint: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
    constraint.isActive = true
    return constraint }()
    
 var tagButtons = [TagButton]() {
    didSet { oldValue.forEach { $0.removeFromSuperview() } }
  }
  

  
  
  private func createButtonWithTitle(_ title: String) -> TagButton {
    let button = TagButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont.font12
    button.sizeToFit()
    button.frame.size.height = (button.titleLabel?.font.pointSize)! + 14
    button.setTitleColor(UIColor.hx9b9b9b, for: .normal)

    let radius = button.frame.height * 0.5
    button.layer.masksToBounds = true
    button.layer.cornerRadius = radius
    button.frame.size.width += radius + 5
    button.backgroundColor = UIColorFromRGB(0xF6F6F6)

    addSubview(button)
    button.isUserInteractionEnabled = false
    
    button.rx.tap.bind {
        self.btnClick?(button)
    }.disposed(by: disposeBag)
    
    return button
  }
  
  public func createCloudTagsWithTitles(_ titles: [String]) {
    tagButtons = titles.map { createButtonWithTitle($0) }
    layoutIfNeeded()
  }
  
    
    public  func layoutThemeWithTerget(_ indexs:[Int],tag:Int) {
        for i in 0..<tagButtons.count {
        let btn  = tagButtons[i]
        btn.titleLabel?.font = UIFont.font15
        let attrStr = NSMutableAttributedString.init(string: btn.titleLabel?.text! ?? "", attributes: [.foregroundColor:UIColor.hx5c5e6b])
        btn.setAttributedTitle(attrStr, for: .normal)
        btn.tag = tag + i
        btn.sizeToFit()
        btn.frame.size.height = (btn.titleLabel?.font.pointSize)! + 26
//        btn.setTitleColor(UIColor.hx5c5e6b, for: .normal)

        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 4
        btn.frame.size.width += 30
        btn.isUserInteractionEnabled = true
    }
        
    for i in indexs {
            let btn  = tagButtons[i]
            let attrStr = NSMutableAttributedString.init(imageName: "hotImage", contentString: btn.titleLabel!.text ?? "", attributedInsertType: .last, label: btn.titleLabel!)
            
            let range = NSRange(location: 0, length: btn.titleLabel!.text!.length)
            attrStr.addAttribute(.foregroundColor, value: UIColor.hx5c5e6b, range: range)
            btn.setAttributedTitle(attrStr, for: .normal)
            btn.sizeToFit()
            btn.frame.size.height = (btn.titleLabel?.font.pointSize)! + 26
            btn.frame.size.width += 30
    }
        
    setNeedsLayout()
    layoutIfNeeded()
    }
    

    public func layoutTagsWithTitles(_ titles: [String]) {
        if titles.count >= tagButtons.count {
            for i in 0..<tagButtons.count {
                let btn  = tagButtons[i]
                btn.titleLabel?.text = titles[i]
                btn.sizeToFit()
                btn.frame.size.height = (btn.titleLabel?.font.pointSize)! + 18
                btn.setTitleColor(UIColor.hx9b9b9b, for: .normal)
                let radius = btn.frame.height * 0.5
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = radius
                btn.frame.size.width += radius + 5
            }
        }
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
    var heightTag: CGFloat = 0
//    if let button = editTagButton.0, editTagButton.top {
//      layoutButton(button, maxViewWidth, &heightTag, &offset)
//    }
//    if let button = editTagButton.0, !editTagButton.top {
//      layoutButton(button, maxViewWidth, &heightTag, &offset)
//    }
    self.tagButtons.forEach { self.layoutButton($0, maxViewWidth, &heightTag, &offset) }
    self.heighConstraint.constant =  offset.y + heightTag + self.buttom
//    print("\(tagButtons)------\(self.heighConstraint.constant)")
    
  }
  
  private func layoutButton(_ button: TagButton, _ maxViewWidth: CGFloat, _ heightTag: inout CGFloat, _ offset: inout CGPoint) {
    heightTag = button.frame.height
    let widthTagButton = button.frame.width
    if (offset.x + widthTagButton + trailing) > maxViewWidth {
      offset.x = leading
      offset.y += heightTag + ySpacing
    }
    if self.hiddeSection {
    if offset.y > heightTag {
        button.isHidden = true
    }else {
        button.isHidden = false
    }
    }
    button.frame.origin = offset
    offset.x += widthTagButton + xSpacing
  }
  
  
}

class TagButton: BaseButton {
    
}
