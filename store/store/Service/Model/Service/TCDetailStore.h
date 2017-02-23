//
//  TCDetailStore.h
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCDetailStore : NSObject

/** 商铺ID */
@property (copy, nonatomic) NSString *ID;
/** 商铺名称 */
@property (copy, nonatomic) NSString *name;
/** 店铺logo */
@property (copy, nonatomic) NSString *logo;

/** 店铺品牌 */
@property (copy, nonatomic) NSString *brand;
/** 略所图 */
@property (copy, nonatomic) NSString *thumbnail;
/** 位置信息 */
@property (copy, nonatomic) NSArray *coordinate;
/** 折扣信息 */
@property ( nonatomic) CGFloat discount;
/** 标志性位置 */
@property (copy, nonatomic) NSString *markPlace;
/** 类别 */
@property (copy, nonatomic) NSString *category;
/** 商家标签 */
@property (copy, nonatomic) NSArray *tags;
/** 区 */
@property (copy, nonatomic) NSString *district;
/** 详细地址 */
@property (copy, nonatomic) NSString *address;
/** 菜系类型 */
@property (copy, nonatomic) NSArray *cookingStyle;

/** 电话号码 */
@property (copy, nonatomic) NSString *phone;
/** 收藏人数 */
@property (nonatomic) NSInteger collectionNum;
/** 人气值 */
@property (nonatomic) NSInteger popularValue;
/** 营业时间 */
@property (copy, nonatomic) NSString *businessHours;
/** 省 */
@property (copy, nonatomic) NSString *province;
/** 市 */
@property (copy, nonatomic) NSString *city;
/** 人均消费 */
@property (assign, nonatomic) NSInteger personExpense;
/** 店铺环境图 */
@property (copy, nonatomic) NSArray *pictures;
/** 辅助设备 */
@property (copy, nonatomic) NSArray *facilities;

@end
