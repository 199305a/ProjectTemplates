//
//  TingYunSDKManager.m
//  CommaUser
//
//  Created by macbook on 2018/11/2.
//  Copyright © 2018年 LikingFit. All rights reserved.
//

#import "TingYunSDKManager.h"
#import <tingyunApp/NBSAppAgent.h>

@implementation TingYunSDKManager

+(void)beginTracer:(NSString*)eventName {
    beginTracer(eventName)
}

+(void)endTracer:(NSString*)eventName {
     endTracer(eventName)
}


@end
