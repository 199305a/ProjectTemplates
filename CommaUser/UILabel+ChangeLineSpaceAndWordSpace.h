//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  HiCatUser
//
//  Created by Marco Sun on 2017/6/14.
//  Copyright © 2017年 Likingfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
- (void)setLineSpace:(CGFloat)space;
- (void) setLineSpace:(CGFloat)space textAlignment:(NSTextAlignment)alignment;
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space;
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space textAlignment:(NSTextAlignment)alignment;

/**
 *  改变字间距
 */
- (void)setWordSpace:(CGFloat)space;
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(CGFloat)lineSpace WordSpace:(CGFloat)wordSpace;

@end

