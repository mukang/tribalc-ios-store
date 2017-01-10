//
//  TCGoods.h
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoods : NSObject

/** 商品ID */
@property (copy, nonatomic) NSString *ID;
/** 商家ID */
@property (copy, nonatomic) NSString *storeId;
/** 商品名称 */
@property (copy, nonatomic) NSString *name;
/** 商品品牌 */
@property (copy, nonatomic) NSString *brand;
/** 商品主图 */
@property (copy, nonatomic) NSString *mainPicture;
/** 原始价格 */
@property (nonatomic) CGFloat originPrice;
/** 销售价格 */
@property (nonatomic) CGFloat salePrice;
/** 总销量 */
@property (nonatomic) NSInteger saleQuantity;
/** 规格文本信息 */
@property (nonatomic, copy) NSString *standardSnapshot;


@end
