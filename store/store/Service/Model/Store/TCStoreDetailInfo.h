//
//  TCStoreDetailInfo.h
//  store
//
//  Created by 穆康 on 2017/1/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCStoreDetailInfo : NSObject

/** 店铺id */
@property (copy, nonatomic) NSString *ID;
/** 店铺logo */
@property (copy, nonatomic) NSString *logo;
/** 背景图 */
@property (copy, nonatomic) NSString *cover;
/** 店铺名称 */
@property (copy, nonatomic) NSString *name;
/** 联系人 */
@property (copy, nonatomic) NSString *linkman;
/** 店铺类型 - GOODS, SET_MEAL */
@property (copy, nonatomic) NSString *storeType;
/** 店铺管理人手机号码 */
@property (copy, nonatomic) NSString *phone;
/** 店铺认证状态 - PROCESSING, FAILURE, SUCCEED */
@property (copy, nonatomic) NSString *authenticationStatus;

/** 标志性位置 */
@property (copy, nonatomic) NSString *markPlace;
/** 分店名称 */
@property (copy, nonatomic) NSString *subbranchName;
/** 销售类型 - FOOD, GIFT, OFFICE, LIVING, HOUSE, MAKEUP, PENETRATION, REPAST, HAIRDRESSING, FITNESS, ENTERTAINMENT, KEEPHEALTHY */
@property (copy, nonatomic) NSString *category;
/** 店铺描述 */
@property (copy, nonatomic) NSString *desc;
/** 其他手机号码 */
@property (copy, nonatomic) NSString *otherPhone;
/** 省 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 区域 */
@property (copy, nonatomic) NSString *district;
/** 详细地址 */
@property (copy, nonatomic) NSString *address;
/** 环境组图 */
@property (copy, nonatomic) NSArray *pictures;
/** 辅助设施 */
@property (copy, nonatomic) NSArray *facilities;
/** 菜系类型 */
@property (copy, nonatomic) NSArray *cookingStyle;
/** 营业时间 */
@property (copy, nonatomic) NSString *businessHours;
/** 位置信息 */
@property (copy, nonatomic) NSArray *coordinate;

@end
