//
//  TCGoods.h
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGoodsPriceAndRepertory.h"

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


@property (copy, nonatomic) NSString *standardId;

@property (copy, nonatomic) NSString *category;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSArray *pictures;

@property (copy, nonatomic) NSString *thumbnail;

@property (copy, nonatomic) NSString *detail;

@property (copy, nonatomic) NSString *note;

@property (copy, nonatomic) NSArray *tags;

@property (copy, nonatomic) NSString *originCountry;

@property (copy, nonatomic) NSString *dispatchPlace;

@property (copy, nonatomic) NSString *expressType;

@property (assign, nonatomic) CGFloat expressFee;

@property (strong, nonatomic) TCGoodsPriceAndRepertory *goodsPriceAndRepertory;

@property (copy, nonatomic) NSArray *standardKeys;

@end
