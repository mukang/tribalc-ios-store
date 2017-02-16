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
/** 辅助设备 */
@property (copy, nonatomic) NSArray *facilities;
/** 折扣信息 */
@property ( nonatomic) CGFloat discount;
/** 标志性位置 */
@property (copy, nonatomic) NSString *markPlace;
/** 类别 */
@property (copy, nonatomic) NSString *category;
/** 商家标签 */
@property (copy, nonatomic) NSArray *tags;

@property (copy, nonatomic) NSString *district;

@property (copy, nonatomic) NSString *cookingStyle;



/** 电话号码 */
@property (copy, nonatomic) NSString *phone;
/** 详细地址 */
@property (copy, nonatomic) NSString *address;
/** 收藏人数 */
@property (nonatomic) NSInteger collectionNum;
/** 人气值 */
@property (nonatomic) NSInteger popularValue;
/** 营业时间 */
@property (copy, nonatomic) NSString *businessHours;

@property (copy, nonatomic) NSString *province;

@property (copy, nonatomic) NSString *city;

@property (assign, nonatomic) NSInteger personExpense;

@property (copy, nonatomic) NSArray *pictures;

@end
