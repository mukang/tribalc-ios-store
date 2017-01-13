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
/** 店铺类型 - GOODS, SET_MEAL */
@property (copy, nonatomic) NSString *storeType;
/** 店铺管理人手机号码 */
@property (copy, nonatomic) NSString *phone;
/** 省 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 区域 */
@property (copy, nonatomic) NSString *district;
/** 发货地址 */
@property (copy, nonatomic) NSString *address;

/** 分店名称 */
@property (copy, nonatomic) NSString *subbranchName;
/** 销售类型 - FOOD, GIFT, OFFICE, LIVING, HOUSE, MAKEUP, PENETRATION, REPAST, HAIRDRESSING, FITNESS, ENTERTAINMENT, KEEPHEALTHY */
@property (copy, nonatomic) NSString *category;
/** 店主姓名 */
@property (copy, nonatomic) NSString *linkman;
/** 其他手机号码 */
@property (copy, nonatomic) NSString *otherPhone;
/** 营业时间 */
@property (copy, nonatomic) NSString *businessHours;
/** 菜系类型 */
@property (copy, nonatomic) NSArray *cookingStyle;
/** 环境图 */
@property (copy, nonatomic) NSArray *surroundingsPicture;
/** 推荐理由 */
@property (copy, nonatomic) NSString *recommendedReason;
/** 推荐话题 */
@property (copy, nonatomic) NSString *topics;
/** 人均消费 */
@property (copy, nonatomic) NSString *personExpense;
/** 预定人数 */
@property (nonatomic) NSInteger reservationNum;
/** 是否接受预定 */
@property (nonatomic) BOOL reservable;
/** 辅助设施 */
@property (copy, nonatomic) NSArray *facilities;
/** 标签 */
@property (copy, nonatomic) NSString *tags;
/** 店铺创建状态 */
@property (copy, nonatomic) NSString *storeCreationStatus;
/** 店铺注册号 */
@property (copy, nonatomic) NSString *registeredNum;
/** 营业执照名称 */
@property (copy, nonatomic) NSString *licenseName;
/** 营业执照照片 */
@property (copy, nonatomic) NSString *licensePicture;
/** 法人姓名 */
@property (copy, nonatomic) NSString *legalPersonName;
/** 法人身份证号 */
@property (copy, nonatomic) NSString *legalPersonIdCardNo;
/** 法人身份证照片 */
@property (copy, nonatomic) NSArray *leagalPersonPicture;
/** 行业许可证类型 */
@property (copy, nonatomic) NSString *threadLicenseType;
/** 许可证名称 */
@property (copy, nonatomic) NSString *threadLicenseName;
/** 经营范围 */
@property (copy, nonatomic) NSString *threadLicenseScope;
/** 许可证照片 */
@property (copy, nonatomic) NSString *threadLicensePicture;

@end
