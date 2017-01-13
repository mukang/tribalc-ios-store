//
//  TCStoreInfo.h
//  store
//
//  Created by 穆康 on 2017/1/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCStoreInfo : NSObject

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

@end
