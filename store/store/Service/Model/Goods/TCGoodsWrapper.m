//
//  TCGoodsWrapper.m
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsWrapper.h"
#import "TCGoods.h"

@implementation TCGoodsWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCGoods class]};
}

@end
