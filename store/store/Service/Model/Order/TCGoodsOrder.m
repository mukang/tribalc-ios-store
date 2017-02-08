//
//  TCGoodsOrder.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrder.h"
#import "TCStoreInfo.h"
#import "TCGoodsOrderItem.h"

@implementation TCGoodsOrder

+ (NSDictionary *)objectClassInArray {
    return @{@"itemList": [TCGoodsOrderItem class]};
}

+ (NSDictionary *)objectClassInDictionary {
    return @{@"store": [TCStoreInfo class]};
}

@end
