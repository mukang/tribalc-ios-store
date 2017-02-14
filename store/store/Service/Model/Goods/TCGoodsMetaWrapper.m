//
//  TCGoodsMetaWrapper.m
//  store
//
//  Created by 王帅锋 on 17/2/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsMetaWrapper.h"
#import "TCGoodsMeta.h"

@implementation TCGoodsMetaWrapper
+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCGoodsMeta class]};
}
@end
