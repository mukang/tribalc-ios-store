//
//  TCPromotionsWrapper.m
//  individual
//
//  Created by 穆康 on 2017/5/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPromotionsWrapper.h"
#import "TCPromotions.h"

@implementation TCPromotionsWrapper

+ (NSDictionary *)objectClassInArray {
    return @{
             @"promotionsList": [TCPromotions class]
             };
}

@end
