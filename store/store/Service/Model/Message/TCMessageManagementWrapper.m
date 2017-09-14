//
//  TCMessageManagementWrapper.m
//  individual
//
//  Created by 穆康 on 2017/9/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMessageManagementWrapper.h"

@implementation TCMessageManagementWrapper

+ (NSDictionary *)objectClassInArray {
    return @{
             @"primary": [TCMessageManagement class],
             @"additional": [TCMessageManagement class]
             };
}

@end
