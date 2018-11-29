//
//  UILabel+ChangeLineSpaceAndWordSpace.m
//  HiCatUser
//
//  Created by Marco Sun on 2017/6/14.
//  Copyright © 2017年 Likingfit. All rights reserved.
//

#import "UILabel+ChangeLineSpaceAndWordSpace.h"


@implementation UILabel (ChangeLineSpaceAndWordSpace)

- (void)setLineSpace:(CGFloat)space {
    [self setLineSpace:space textAlignment:NSTextAlignmentLeft];
}

- (void) setLineSpace:(CGFloat)space textAlignment:(NSTextAlignment)alignment {
    [UILabel changeLineSpaceForLabel:self WithSpace:space textAlignment:alignment];
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space {
    [UILabel changeLineSpaceForLabel:label WithSpace:space textAlignment:NSTextAlignmentLeft];
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space textAlignment:(NSTextAlignment)alignment {
    
    NSString *labelText = label.text;
    if (labelText == nil) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(CGFloat)space {
    
    NSString *labelText = label.text;
    if (labelText == nil) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(CGFloat)lineSpace WordSpace:(CGFloat)wordSpace {
    
    NSString *labelText = label.text;
    if (labelText == nil) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

- (void)setWordSpace:(CGFloat)space {
    [UILabel changeWordSpaceForLabel:self WithSpace:space];
}

@end
