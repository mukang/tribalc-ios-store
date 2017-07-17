//
//  TCWalletAccount.h
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWalletAccount : NSObject

/** 与用户id一致 */
@property (copy, nonatomic) NSString *ID;
/** 账户余额 */
@property (nonatomic) CGFloat balance;
/** 单笔转出手续费 */
@property (nonatomic) double withdrawCharge;
/** 账户状态 */
@property (copy, nonatomic) NSString *state;
/** 密码 MD5 签名 */
@property (copy, nonatomic) NSString *password;
/** 最后时间 */
@property (nonatomic) NSInteger lastTrading;
/** 银行卡列表 */
@property (copy, nonatomic) NSArray *bankCards;
/** 账号类型 */
@property (copy, nonatomic) NSString *accountType;

@end
