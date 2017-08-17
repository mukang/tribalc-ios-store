//
//  TCHomeMessageType.h
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCMessageType) {
    TCMessageTypeAccountWalletPayment = 0,          // "钱包助手", "付款通知"
    TCMessageTypeAccountWalletRecharge,             // "钱包助手", "充值到账"
    TCMessageTypeCreditEnable,                      // "授信助手", "开通授信"
    TCMessageTypeCreditDisable,                     // "授信助手", "授信额度冻结"
    TCMessageTypeCreditBillGeneration,              // "授信助手", "账单生成"
    TCMessageTypeCreditBillPayment,                 // "授信助手", "账单支付"
    TCMessageTypeRentCheckIn,                       // "公寓管家", "入住通知"
    TCMessageTypeRentBillGeneration,                // "公寓管家", "缴租提醒"
    TCMessageTypeRentBillPayment,                   // "公寓管家", "租金缴纳"
    TCMessageTypeTenantRecharge,                    // "商户助手", "收款到账"
    TCMessageTypeTenantWithdraw,                    // "商户助手", "提现到账"
    TCMessageTypeCompaniesAdmin,                    // "企业办公", "管理变更"
    TCMessageTypeCompaniesRentBillGeneration,       // "企业办公", "缴租提醒"
    TCMessageTypeCompaniesRentBillPayment,          // "企业办公", "租金缴纳"
    TCMessageTypeAccountRegister                    // "账户推送", "欢迎登录"
};

@interface TCHomeMessageType : NSObject

/** 类型（自己转换的） */
@property (nonatomic) TCMessageType type;
/** 消息类型枚举 */
@property (copy, nonatomic) NSString *homeMessageTypeEnum;
/** 消息类型属类 */
@property (copy, nonatomic) NSString *homeMessageTypeCategory;
/** 具体消息类型 */
@property (copy, nonatomic) NSString *homeMessageType;

@end
