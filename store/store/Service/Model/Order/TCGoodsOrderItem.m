//
//  TCGoodsOrderItem.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderItem.h"
#import "TCGoods.h"

@implementation TCGoodsOrderItem

+ (NSDictionary *)objectClassInDictionary {
    return @{@"goods": [TCGoods class]};
}

@end
