//
//  TCGoodsMeta.h
//  store
//
//  Created by 王帅锋 on 17/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGoodsPriceAndRepertory.h"

@interface TCGoodsMeta : NSObject

@property (copy, nonatomic) NSString *ID;

@property (assign, nonatomic) NSInteger createTime;

@property (assign, nonatomic) BOOL published;
/** 规格组id */
@property (copy, nonatomic) NSString *standardId;

@property (copy, nonatomic) NSString *category;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *brand;

@property (copy, nonatomic) NSString *mainPicture;

@property (copy, nonatomic) NSArray *pictures;

@property (copy, nonatomic) NSString *thumbnail;

/** 商品详情图片数组 */
@property (copy, nonatomic) NSArray *detail;

@property (assign, nonatomic) NSInteger saleQuantity;

@property (copy, nonatomic) NSString *note;

@property (copy, nonatomic) NSArray *tags;

@property (copy, nonatomic) NSString *originCountry;

@property (copy, nonatomic) NSString *dispatchPlace;
/** 快递包邮类型 */
@property (copy, nonatomic) NSString *expressType;

@property (assign, nonatomic) double expressFee;

@property (strong, nonatomic) TCGoodsPriceAndRepertory *priceAndRepertory;

@property (copy, nonatomic) NSArray *standardKeys;

@property (copy, nonatomic) NSString *number;
/** 是否为主商品 */
@property (assign, nonatomic) BOOL primary;
/** 每日限量 */
@property (assign, nonatomic) NSInteger dailyLimit;

@end
