//
//  UIImage+Blur.h
//  CommaUser
//
//  Created by Marco Sun on 2018/4/9.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

+ (UIImage *)blurryImage:(UIImage *)image withMaskImage:(UIImage *)maskImage blurLevel:(CGFloat)blur;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+(UIColor*)mostColor:(UIImage*)image;

@end
