//
//  TCHomeMessageWrapper.m
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageWrapper.h"

@implementation TCHomeMessageWrapper

+ (NSDictionary *)objectClassInArray {
    return @{
             @"content": [TCHomeMessage class]
             };
}

@end
