//
//  CIImage+CIImage_Category.h
//  CommaUser
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 LikingFit. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImage (CIImage_Category)
#pragma mark - 生成高清图片
- (UIImage *)getQRImageWithSize:(CGFloat) size;
@end

NS_ASSUME_NONNULL_END
