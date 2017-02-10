//
//  TCReservation.h
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 服务预定信息
 */
@interface TCReservation : NSObject

/** 预定ID */
@property (copy, nonatomic) NSString *ID;
/** 商家ID */
@property (copy, nonatomic) NSString *storeId;
/** 服务ID */
@property (copy, nonatomic) NSString *storeSetMealId;
/** 店铺名称 */
@property (copy, nonatomic) NSString *storeName;
/** 标志性位置 */
@property (copy, nonatomic) NSString *markPlace;
/** 主图 */
@property (copy, nonatomic) NSString *mainPicture;
/** 约定时间 */
@property (nonatomic) NSUInteger appointTime;
/** 预定人数 */
@property (nonatomic) NSInteger personNum;
/** 标签 Default WIFI From { WIFI, PARKING ...} */
@property (strong, nonatomic) NSArray *tags;
/** 预定状态 Default PROCESSING From enum ReservationStatus{ CANNEL, PROCESSING, FAILURE, SUCCEED } */
@property (copy, nonatomic) NSString *status;

/** 联系人 */
@property (copy, nonatomic) NSString *linkman;
/** 性别 Default FEMALE From { FEMALE, MALE, UNKNOWN } */
@property (copy, nonatomic) NSString *sex;
/** 联系电话 */
@property (copy, nonatomic) NSString *phone;
/** 备注 */
@property (copy, nonatomic) NSString *note;
/** 地址 */
@property (copy, nonatomic) NSString *address;

@end
