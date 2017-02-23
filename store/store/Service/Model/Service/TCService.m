//
//  TCService.m
//  store
//
//  Created by 穆康 on 2017/2/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCService.h"

@implementation TCService

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"store":[TCListStore class]
             };
}

@end
