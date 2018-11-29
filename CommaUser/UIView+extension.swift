//
//  UIView-ShortCuts.swift
//  Swift-Useful-Extensions
//
//  Created by Yin Xu on 6/9/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

import UIKit
import MBProgressHUD

//UIView
extension UIView {
    var width:      CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    var height:     CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    var size:       CGSize  {
        get {
            return self.frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(_ x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    func setY(_ y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    func setCenterY(_ y:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func coloredSubviews() {
        for view: UIView in self.subviews {
            view.backgroundColor = UIColor.randomColor()
            
            for subView: UIView in view.subviews {
                subView.backgroundColor = UIColor.randomColor()
            }
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func addFullSizeSubView(_ theV: UIView) {
        let conV = self
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.edges.equalTo(conV)
        }
    }
    
    func addCenterSubView(_ theV: UIView) {
        let conV = self
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.center.equalTo(conV)
        }
    }
    
    func addFullSizeSubViewBelowNavBar(_ theV: UIView) {
        let conV = self
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.edges.equalTo(conV).inset(UIEdgeInsetsMake(Layout.TopBarHeight, 0, 0, 0))
        }
    }
    
    func addFixViewWithPreV(_ preV: UIView, height: CGFloat) -> BaseView {
        let conV = self
        let theV = BaseView()
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.top.equalTo(preV.snp.bottom)
            make.height.equalTo(height)
            make.left.equalTo(conV)
            make.right.equalTo(conV)
        }
        
        return theV
    }
    
    func addLeftFixView() -> BaseView {
        return addLeftFixViewWithWidth(0)
    }
    
    func addLeftFixViewWithWidth(_ width: CGFloat) -> BaseView {
        let conV = self
        let theV = BaseView()
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(conV)
            make.width.equalTo(width)
        }
        
        return theV
    }
    
    func addBottomFixView(_ preV: UIView) -> BaseView {
        return addBottomFixViewWithHeight(0, preV: preV)
    }
    
    func addBottomFixViewWithHeight(_ height: CGFloat, preV: UIView) -> BaseView {
        let conV = self
        let theV = BaseView()
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.top.equalTo(preV.snp.bottom)
            make.height.equalTo(height)
            make.left.right.bottom.equalTo(conV)
        }
        
        return theV
    }
    
    func bounceSelf() {
        let percent:CGFloat = 0.95
        self.transform = CGAffineTransform(scaleX: percent, y: percent)
        UIView.animate(withDuration: Layout.AnimateDuration, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: UIViewAnimationOptions(), animations: { self.transform = CGAffineTransform.identity }, completion: nil)
    }
    
    func bounceSelfToLarger(_ larger: Bool) {
        let multiplicator: CGFloat = larger ? -1:1
        let percent: CGFloat = 1 + 0.05*multiplicator
        self.transform = CGAffineTransform(scaleX: percent, y: percent)
        UIView.animate(withDuration: Layout.AnimateDuration, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: UIViewAnimationOptions(), animations: { self.transform = CGAffineTransform.identity }, completion: nil)
    }
    
    func convetSelfFrameToView(_ view: UIView) -> CGRect {
        return (superview?.convert(frame, to: view))!
    }
    
    class func springAnimateWithDuration(_ duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: Layout.AnimateDuration, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
            animations()
        }, completion: { result in
            if let closure = completion {
                closure(result)
            }
        })
    }
    
    func moveToFront() {
        self.superview?.bringSubview(toFront: self)
    }
    
    func hideAnimatedUseAlpha() {
        UIView.animate(withDuration: Layout.AnimateDuration, animations: {
            self.alpha = 0
        })
    }
    
    func showAnimatedUseAlphaBounce() {
        UIView.animate(withDuration: Layout.AnimateDuration, animations: {
            self.alpha = 1
        }, completion: nil)
        
        self.bounceSelf()
    }
    
    func animateAlphaRemoveFromSuperView() {
        UIView.animate(withDuration: Layout.AnimateDuration, animations: {
            self.alpha = 0
        }, completion: { (complete) in
            self.removeFromSuperview()
        })
    }
    
    func animatedShowInView(_ inView: UIView) {
        self.animatedShowInView(inView, insets: UIEdgeInsets.zero)
    }
    
    func animatedShowInView(_ inView: UIView, insets: UIEdgeInsets) {
        self.animatedShowInView(inView, insets: insets, dismissOnTapCover: true)
    }
    
    func animatedShowInView(_ inView: UIView, insets: UIEdgeInsets, dismissOnTapCover: Bool) {
        //add container view
        let conV = BaseView()
        inView.addFullSizeSubView(conV)
        
        //add cover view
        let coverV = CoverView()
        conV.addFullSizeSubView(coverV)
        
        if dismissOnTapCover {
            let tapGes = UITapGestureRecognizer()
            coverV.addGestureRecognizer(tapGes)
            
            tapGes.rx.event.bind { (ges) in
                conV.animateAlphaRemoveFromSuperView()
                }.disposed(by: coverV.disposeBag)
        }
        
        //add sub view
        var theV: UIView!
        theV = self
        
        conV.addSubview(theV)
        theV.snp.makeConstraints { (make) in
            make.edges.equalTo(conV).inset(insets)
        }
        theV.alpha = 0
        theV.layoutIfNeeded()
        
        UIView.animate(withDuration: Layout.AnimateDuration, animations: {
            theV.alpha = 1
        }, completion: nil)
        
        theV.bounceSelf()
    }
    
    /**
     bgColor: 0x566a77
     cornerRadius: 4
     */
    func setRoundAndGrey() {
        setRoundWithCornerRadius(4, bgColor: UIColor.hexColor(0x566a77))
    }
    
    /**
     bgColor: 0xf8f8f8
     cornerRadius: 5
     */
    func setRoundAndLightGrey() {
        setRoundWithCornerRadius(5, bgColor: UIColor.hexColor(0xf8f8f8))
        
    }
    
    func setRoundWithCornerRadius(_ radius: CGFloat, bgColor: UIColor) {
        backgroundColor = bgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    
    func obtainAutoLayoutSize() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        let height = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return height
    }
    
}


extension UIView {
    
    fileprivate struct AssociatedKeys {
        static var RedDot = "_RedDot"
    }
    
    var redDot: CALayer! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.RedDot) as? CALayer
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.RedDot, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func redDotInitial() {
        if redDot == nil {
            redDot = CALayer.init()
            let dotSize = CGSizeMake(5)
            setUpDotSize(dotSize: dotSize)
            redDot.backgroundColor = UIColor.hexColor(0xff4e4e).cgColor
            redDot.cornerRadius = dotSize.width / 2
            redDot.masksToBounds = true
        }
    }
    
    func showRedDot() {
        redDotInitial()
        if let sup = redDot.superlayer, sup == self.layer {
            redDot.isHidden = false
        } else {
            redDot.removeFromSuperlayer()
            self.layer.addSublayer(redDot)
        }
        self.clipsToBounds = false
    }
    
    func dismissRedDot() {
        guard let _ = redDot else {return}
        redDot.removeFromSuperlayer()
    }
    
    
    func redDotInset(point: CGPoint) {
        redDotInitial()
        setUpDotSize(dotSize: CGSizeMake(5))
        redDot.frame.origin.x += point.x
        redDot.frame.origin.y += point.y
    }
    
    private func setUpDotSize(dotSize: CGSize) {
        self.layoutIfNeeded()
        var frame = self.frame
        frame.origin.x = frame.width + 2
        frame.origin.y = -2
        frame.size.width = dotSize.width
        frame.size.height = dotSize.height
        redDot.frame = frame
    }
    
}

extension UIView {
    
    func bringSubviewToFrontButHUD(_ view: UIView) {
        
        if let hud = self.subviews.last as? MBProgressHUD {
            self.insertSubview(view, belowSubview: hud)
            return
        }
        bringSubview(toFront: view)
    }
    
    func addSubviewBehindHUD(_ view: UIView) {
        if let hud = self.subviews.last as? MBProgressHUD {
            self.insertSubview(view, belowSubview: hud)
            return
        }
        addSubview(view)
    }
}


extension UIView {
    func setAnchorPoint(_ anchorPoint: CGPoint){
        var newPoint = CGPoint(x: bounds.size.width * anchorPoint.x, y: bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
}

extension UIView {
    
    //查找view所在的控制器
    func controller() -> UIViewController? {
        
        var tempResponser: UIResponder? = self.next
        var findNext: Bool {
            return !(tempResponser is UIViewController) && tempResponser != nil
        }
        
        while findNext  {
            tempResponser = tempResponser?.next
        }
        
        guard let vc = tempResponser as? UIViewController else {
            return nil
        }
        
        return vc
        
    }
    
}

extension CALayer {
    func adjustAnchorPoint(_ anchorPoint: CGPoint){
        
        let newPosition = CGPoint(x: anchorPoint.x*frame.width+frame.origin.x, y: anchorPoint.y*frame.height+frame.origin.y)
        self.position = newPosition
        self.anchorPoint = anchorPoint
    }
}

extension UILabel {
    
    func LayoutFontByIphone6() {
        
        if Layout.ScreenWidth < 375 {
            let font = self.font
            self.font = font?.withSize((font?.pointSize)!-1)
        }
        
    }
}

extension UIView {
    
    var toImage: UIImage? {
        return toImage(with: bounds.size)
    }
    
    func toImage(with: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        drawHierarchy(in: CGRect.init(origin: .zero, size: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIScrollView {
    
    var toLongImage: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(contentSize, true, UIScreen.main.scale)
        //保存collectionView当前的偏移量
        let savedContentOffset = contentOffset
        let saveFrame = frame
        
        //将collectionView的偏移量设置为(0,0)
        contentOffset = .zero
        frame = CGRectMake(0, 0, contentSize.width, contentSize.height)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        //在当前上下文中渲染出collectionView
        layer.render(in: context)
        //截取当前上下文生成Image
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        //恢复collectionView的偏移量
        contentOffset = savedContentOffset
        frame = saveFrame
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
}


extension UITableView {
    
    var isAutoEstimatedHeightEnable: Bool {
        set {
            let height = newValue ? UITableViewAutomaticDimension : 0
            estimatedRowHeight = height
            estimatedSectionHeaderHeight = height
            estimatedSectionFooterHeight = height
        }
        
        get {
            return (estimatedRowHeight == estimatedSectionHeaderHeight) && (estimatedRowHeight == estimatedSectionFooterHeight) && (estimatedRowHeight == UITableViewAutomaticDimension)
        }
    }
}

extension UIView {
    
    func shadow(with color: UIColor? = UIColor.hx129faa.withAlphaComponent(0.2), offset: CGSize = CGSizeMake(0, 3)) {
        clipsToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = offset
        layer.shadowRadius = 3
    }
    
    func shadowReset() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
    }
}


extension UIView {
    func custom(size: CGSize, corner: UIRectCorner, cornerRadius: CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: CGRect(origin: .zero, size: size), byRoundingCorners: corner, cornerRadii: CGSizeMake(cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame =  CGRect(origin: .zero, size: size)
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

extension UIScrollView {
    func removeStickiness(height: CGFloat) {
        if contentOffset.y <= height && contentOffset.y >= 0 {
            contentInset = UIEdgeInsetsMake(-contentOffset.y, 0, 0, 0)
        }
        else if contentOffset.y >= height {
            contentInset = UIEdgeInsetsMake(-height, 0, 0, 0)
        }
    }
}


