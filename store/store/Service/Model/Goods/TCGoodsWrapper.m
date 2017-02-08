//
//  TCGoodsWrapper.m
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsWrapper.h"
#import "TCGoodsMeta.h"

@implementation TCGoodsWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCGoodsMeta class]};
}

@end
