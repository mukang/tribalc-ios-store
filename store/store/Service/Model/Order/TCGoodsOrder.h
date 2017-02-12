//
//  TCGoodsOrder.h
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCStoreInfo;

/**
 订单
 */
@interface TCGoodsOrder : NSObject

/** 订单ID */
@property (copy, nonatomic) NSString *ID;
/** 订单编号 */
@property (copy, nonatomic) NSString *orderNum;
/** 用户ID */
@property (copy, nonatomic) NSString *ownerId;
/** 购买账户（手机号） */
@property (copy, nonatomic) NSString *user;
/** 购买人昵称 */
@property (copy, nonatomic) NSString *nickName;
/** 购买人头像 */
@property (copy, nonatomic) NSString *picture;
/** 物流单号 */
@property (copy, nonatomic) NSString *logisticsNum;
/** 收获地址 */
@property (copy, nonatomic) NSString *address;
/** 配送方式 Default NOT_PAYPOSTAGE From { PAYPOSTAGE, NOT_PAYPOSTAGE } */
@property (copy, nonatomic) NSString *expressType;
/** 邮递费 */
@property (nonatomic) CGFloat expressFee;
/** 价格合计 */
@property (nonatomic) CGFloat totalFee;
/** 订单补充说明 */
@property (copy, nonatomic) NSString *note;
/** 支付方式 Default BALANCE From { BALANCE, ALIPAY, WEICHAT, BANKCARD } */
@property (copy, nonatomic) NSString *payChannel;
/** 订单状态 Default NO_SETTLE From enum OrderStatus{ CANCEL, NO_SETTLE, SETTLE, DELIVERY, RECEIVED } */
@property (copy, nonatomic) NSString *status;
/** 创建时间 */
@property (nonatomic) NSUInteger createTime;
/** 结算时间 */
@property (nonatomic) NSUInteger settleTime;
/** 发货时间 */
@property (nonatomic) NSUInteger deliveryTime;
/** 收货时间 */
@property (nonatomic) NSUInteger receivedTime;
/** 商铺简要信息 */
@property (strong, nonatomic) TCStoreInfo *store;
/** 关联的商品信息，TCGoodsOrderItem对象数组 */
@property (copy, nonatomic) NSArray *itemList;

@end
