//
//  TCGoodsOrderWrapper.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderWrapper.h"
#import "TCGoodsOrder.h"

@implementation TCGoodsOrderWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCGoodsOrder class]};
}

@end
