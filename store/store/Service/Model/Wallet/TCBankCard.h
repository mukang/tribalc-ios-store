//
//  TCBankCard.h
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCBankCardType) {
    TCBankCardTypeNormal = 0,
    TCBankCardTypeWithdraw
};

@interface TCBankCard : NSObject

/** 银行卡ID */
@property (copy, nonatomic) NSString *ID;
/** 用户ID */
@property (copy, nonatomic) NSString *ownerId;
/** 用户名 */
@property (copy, nonatomic) NSString *userName;
/** 开户行名称 */
@property (copy, nonatomic) NSString *bankAddress;
/** 银行名称 */
@property (copy, nonatomic) NSString *bankName;
/** 银行代码 */
@property (copy, nonatomic) NSString *bankCode;
/** 银行卡账号 */
@property (copy, nonatomic) NSString *bankCardNum;
/** 手机号 */
@property (copy, nonatomic) NSString *phone;

/** 银行logo */
@property (copy, nonatomic) NSString *logo;
/** 背景图 */
@property (copy, nonatomic) NSString *bgImage;
/** 显示删除按钮 */
@property (nonatomic) BOOL showDelete;
/** 是否为对公账户 */
@property (assign, nonatomic) BOOL personal;
/** 开户行 */
@property (copy, nonatomic) NSString *department;


/** 绑卡类型 Default NORMAL From { NORMAL // 通用卡, WITHDRAW //提现卡 } */
@property (copy, nonatomic) NSString *bindType;
/** 银行卡类型 */
@property (nonatomic) TCBankCardType type;

/** 银行单笔最大提现金额 */
@property (nonatomic) long long maxWithdrawAmount;
/** 银行单笔最大消费金额 */
@property (nonatomic) long long maxPaymentAmount;

@end
