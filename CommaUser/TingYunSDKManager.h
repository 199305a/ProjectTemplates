//
//  TingYunSDKManager.h
//  CommaUser
//
//  Created by macbook on 2018/11/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TingYunSDKManager : NSObject

+(void)beginTracer:(NSString*)eventName;
+(void)endTracer:(NSString*)eventName;
@end

NS_ASSUME_NONNULL_END
