//
//  TCGoodsMetaWrapper.h
//  store
//
//  Created by 王帅锋 on 17/2/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoodsMetaWrapper : NSObject
/** 当前类别 */
@property (copy, nonatomic) NSString *category;
/** 当前排序规则 */
@property (copy, nonatomic) NSString *sort;
/** 当前结果中的前置跳过 */
@property (copy, nonatomic) NSString *prevSkip;
/** 当前结果中的最后跳过规则，可用于下次查询 */
@property (copy, nonatomic) NSString *nextSkip;
/** 是否还有条目待获取 */
@property (nonatomic) BOOL hasMore;
/** 商品列表，TCGoods对象数组 */
@property (copy, nonatomic) NSArray *content;
/** 是否已发布 */
@property (assign, nonatomic) BOOL published;
/** 销售中的商品数量 */
@property (assign, nonatomic) NSInteger publishedAmount;
/** 仓库中的商品数量 */
@property (assign, nonatomic) NSInteger unpublishedAmount;
@end
