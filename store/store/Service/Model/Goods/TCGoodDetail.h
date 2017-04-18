//
//  TCGoodDetail.h
//  individual
//
//  Created by WYH on 16/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoods.h"
#import "TCStoreInfo.h"

@interface TCGoodDetail : NSObject


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


/** 商品详情标题 */
@property (copy, nonatomic) NSString *title;
/** 规格组ID */
@property (copy, nonatomic) NSString *standardId;
/** 规格描述镜像 */
@property (copy, nonatomic) NSString *standardSnapshot;
/** 是否为镜像信息 */
@property (nonatomic) BOOL snapshot;
/** 是否已发布 */
@property (nonatomic) BOOL published;
/** 细分类别 */
@property (nonatomic, copy) NSString *category;
/** 商品组图片 */
@property (copy, nonatomic) NSArray *pictures;
/** 商品缩略图 */
@property (copy, nonatomic) NSString *thumbnail;
/** 图文详情 */
@property (copy, nonatomic) NSArray *detail;
/** 库存信息 */
@property (nonatomic) NSInteger repertory;
/** 简短说明 */
@property (nonatomic, copy) NSString *note;
/** 标签 */
@property (nonatomic, copy) NSArray *tags;
/** 原产地 */
@property (copy, nonatomic) NSString *originCountry;
/** 发货地 */
@property (copy, nonatomic) NSString *dispatchPlace;


@property (copy, nonatomic) NSString *number;

@property (strong, nonatomic) TCStoreInfo *tMarkStore;

@end
