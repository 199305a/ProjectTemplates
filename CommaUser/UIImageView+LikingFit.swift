//
//  UIImageView+LikingFit.swift
//  CommaUser
//
//  Created by Marco Sun on 16/9/13.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func addFadeAnimation() {
        let tran = CATransition.init()
        tran.type = kCATransitionFade
        tran.duration = 0.4
        self.layer.add(tran, forKey: nil)
    }
    
    
    func lf_setImage(with url: Foundation.URL!) {
        lf_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!) {
        lf_setImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setImage(with url: Foundation.URL!, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.retryFailed, progress: nil, completed: completedBlock)
    }
    
    func lf_setImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions) {
        lf_setImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: completedBlock)
    }
    
    func lf_setImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setImage(with: url, placeholderImage: placeholder, options: options, progress: nil, completed: completedBlock)
    }
    
    func lf_setImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock!, completed completedBlock: SDExternalCompletionBlock!) {
        guard url != nil else {
            image = placeholder
            return
        }
        sd_setImage(with: url, placeholderImage: placeholder, options: options, progress: progressBlock) { (image, error, type, url) in
            completedBlock?(image, error, type, url)
        }
    }
}

extension UIImageView {
    
    func lf_setAnimatingImage(with url: Foundation.URL!) {
        lf_setAnimatingImage(with: url, placeholderImage: nil, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!) {
        lf_setAnimatingImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setAnimatingImage(with: url, placeholderImage: nil, options: SDWebImageOptions.retryFailed, progress: nil, completed: completedBlock)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions) {
        lf_setAnimatingImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: nil)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setAnimatingImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.retryFailed, progress: nil, completed: completedBlock)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, completed completedBlock: SDExternalCompletionBlock!) {
        lf_setAnimatingImage(with: url, placeholderImage: placeholder, options: options, progress: nil, completed: completedBlock)
    }
    
    func lf_setAnimatingImage(with url: Foundation.URL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock!, completed completedBlock: SDExternalCompletionBlock!) {
        
        lf_setImage(with: url, placeholderImage: placeholder, options: options, progress: progressBlock) { [unowned self] (image, error, type, url) in
            completedBlock?(image, error, type, url)
            guard error == nil else { return }
            self.addFadeAnimation()
        }
    }
    
}

