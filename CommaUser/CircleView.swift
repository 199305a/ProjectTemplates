//
//  CircleView.swift
//  CommaUser
//
//  Created by lekuai on 16/12/28.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

class CircleView: BaseView {

    static let defaultValueColor = UIColor.hx596167
    
    var progress = CGFloat(1) {
        didSet {
            setNeedsDisplay()
            if showPercentEnable {
                percentLabal.text = percentDes
            }
        }
    }
    
    let startAngle = CGFloat(-(Double.pi / 2))
    var endAngle: CGFloat {
        let pro = isAnimating ? tempProgress : progress
        return pro * CGFloat(Double.pi) * 2 + startAngle
    }
    
    var borderWidth = CGFloat(3)
    
    var color: UIColor = UIColor.red
    
    var showPercentEnable = false
    
    var fractionNum = 0
    
    var percentDes: String {
        return String(format: "%.\(fractionNum)f%%", progress*100)
    }
    
    var percentAttrDes: NSAttributedString {
        let attrStr = NSMutableAttributedString(string: String(format: "%.\(fractionNum)f", progress*100), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: percentFont])
        let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: Text.Impact, size: 20) ?? UIFont.systemFont(ofSize: 20)]
        attrStr.append(NSAttributedString(string: "%", attributes: attr))
        return attrStr
    }

    var percentLabal: BaseLabel!
    
    var percentFont: UIFont = UIFont(name: Text.Impact, size: 26) ?? UIFont.systemFont(ofSize: 26) {
        didSet{
            percentLabal.font = percentFont
        }
    }
    
    var isAnimating: Bool {
        return animLink != nil
    }
    
    init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        percentLabal = BaseLabel()
        percentLabal.font = percentFont
        percentLabal.textColor = UIColor.white
        percentLabal.text = percentDes
        percentLabal.textAlignment = .center
        percentLabal.adjustsFontSizeToFitWidth = true
        addSubview(percentLabal)
        
        percentLabal.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self.snp.width).offset(-2*borderWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        drawCircleBorder(context: context, rect: rect, startAngle: endAngle, endAngle: startAngle + CGFloat(2 * Double.pi), color: UIColorFromRGB(0xCCCCCC))
        
        drawCircleBorder(context: context, rect: rect, startAngle: startAngle, endAngle: endAngle, color: color, lineCap: CGLineCap.round)
        
        percentLabal.isHidden = !showPercentEnable
        
        if !isAnimating {
            percentLabal.attributedText = percentAttrDes
        }
        
    }
    
    func drawCircleBorder(context: CGContext, rect: CGRect, startAngle: CGFloat, endAngle: CGFloat, color: UIColor, lineCap: CGLineCap? = nil) {
        
        let radius = min(rect.width, rect.height) / 2 - borderWidth/2
        
        context.saveGState()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width/2, y: rect.height/2), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        color.setStroke()
        context.addPath(path.cgPath)
        context.setLineWidth(borderWidth)
        if let cap = lineCap {
            context.setLineCap(cap)
        }
        
        context.strokePath()
        
        context.restoreGState()
        
        
        
    }
    
    //MARK: - animate
    var tempProgress:CGFloat = 0
    var animTime: Double = 1
    var animLink: CADisplayLink?
    func animate(_ time: Double) {
        stopAnimate()
        animTime = time
        animLink = CADisplayLink(target: self, selector: #selector(animateUnit))
        animLink?.frameInterval =  1
        animLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc func animateUnit() {
        guard let link = animLink else { return }
        
        let space = progress / (CGFloat(animTime) / (CGFloat(link.frameInterval)/60.0))
        tempProgress += space
        
        let attrStr = NSMutableAttributedString(string: String(format: "%.\(fractionNum)f", min(tempProgress,progress)*100), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: percentFont])
        let attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: Text.Impact, size: 20) ?? UIFont.systemFont(ofSize: 20)]
        attrStr.append(NSAttributedString(string: "%", attributes: attr))
        percentLabal.attributedText = attrStr
        
        if tempProgress >= progress {
            stopAnimate()
        }
        
        setNeedsDisplay()
        
        
    }
    
    func stopAnimate() {
        if animLink != nil {
            animLink!.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            animLink!.invalidate()
            animLink = nil
            tempProgress = 0
        }
    }
    
}
