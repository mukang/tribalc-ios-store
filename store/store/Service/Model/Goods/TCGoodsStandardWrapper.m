//
//  TCGoodsStandardWrapper.m
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardWrapper.h"
#import "TCGoodsStandardMate.h"

@implementation TCGoodsStandardWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCGoodsStandardMate class]};
}

@end
