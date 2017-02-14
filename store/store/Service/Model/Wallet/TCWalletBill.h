//
//  TCWalletBill.h
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWalletBill : NSObject

/** 账单ID */
@property (copy, nonatomic) NSString *ID;
/** 己方ID */
@property (copy, nonatomic) NSString *ownerId;
/** 交易时间 */
@property (nonatomic) NSInteger createTime;
/** 账单说明 */
@property (copy, nonatomic) NSString *title;
/** 对方ID */
@property (copy, nonatomic) NSString *annotherId;
/** 交易额 */
@property (nonatomic) CGFloat amount;
/** 己方账户余额 */
@property (nonatomic) CGFloat balance;
/** 交易类型 */
@property (copy, nonatomic) NSString *tradingType;
/** 支付方式 */
@property (copy, nonatomic) NSString *payChannel;
/** 关联订单ID */
@property (copy, nonatomic) NSString *associatedOrderId;
/** 备注信息 */
@property (copy, nonatomic) NSString *note;

/** 月份信息 */
@property (copy, nonatomic) NSString *monthDate;
/** 周信息 */
@property (copy, nonatomic) NSString *weekday;
/** 日期时间 */
@property (copy, nonatomic) NSString *detailTime;
/** 交易具体日期时间 */
@property (copy, nonatomic) NSString *tradingTime;

@end
