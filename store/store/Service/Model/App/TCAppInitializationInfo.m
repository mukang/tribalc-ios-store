//
//  TCAppInitializationInfo.m
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppInitializationInfo.h"
#import "TCAppVersion.h"
#import "TCPromotions.h"
#import "TCFeatureSwitches.h"

@implementation TCAppInitializationInfo

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"app": [TCAppVersion class],
             @"promotions": [TCPromotions class],
             @"switches": [TCFeatureSwitches class]
             };
}

@end
