//
//  TCHomeMessageType.m
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageType.h"

@implementation TCHomeMessageType

- (void)setHomeMessageTypeEnum:(NSString *)homeMessageTypeEnum {
    _homeMessageTypeEnum = homeMessageTypeEnum;
    
    if ([homeMessageTypeEnum isEqualToString:@"ACCOUNT_WALLET_PAYMENT"]) {
        _type = TCMessageTypeAccountWalletPayment;
    } else if ([homeMessageTypeEnum isEqualToString:@"ACCOUNT_WALLET_RECHARGE"]) {
        _type = TCMessageTypeAccountWalletRecharge;
    } else if ([homeMessageTypeEnum isEqualToString:@"CREDIT_ENABLE"]) {
        _type = TCMessageTypeCreditEnable;
    } else if ([homeMessageTypeEnum isEqualToString:@"CREDIT_DISABLE"]) {
        _type = TCMessageTypeCreditDisable;
    } else if ([homeMessageTypeEnum isEqualToString:@"CREDIT_BILL_GENERATION"]) {
        _type = TCMessageTypeCreditBillGeneration;
    } else if ([homeMessageTypeEnum isEqualToString:@"CREDIT_BILL_PAYMENT"]) {
        _type = TCMessageTypeCreditBillPayment;
    } else if ([homeMessageTypeEnum isEqualToString:@"RENT_CHECK_IN"]) {
        _type = TCMessageTypeRentCheckIn;
    } else if ([homeMessageTypeEnum isEqualToString:@"RENT_BILL_GENERATION"]) {
        _type = TCMessageTypeRentBillGeneration;
    } else if ([homeMessageTypeEnum isEqualToString:@"RENT_BILL_PAYMENT"]) {
        _type = TCMessageTypeRentBillPayment;
    } else if ([homeMessageTypeEnum isEqualToString:@"TENANT_RECHARGE"]) {
        _type = TCMessageTypeTenantRecharge;
    } else if ([homeMessageTypeEnum isEqualToString:@"TENANT_WITHDRAW"]) {
        _type = TCMessageTypeTenantWithdraw;
    } else if ([homeMessageTypeEnum isEqualToString:@"COMPANIES_ADMIN"]) {
        _type = TCMessageTypeCompaniesAdmin;
    } else if ([homeMessageTypeEnum isEqualToString:@"COMPANIES_RENT_BILL_GENERATION"]) {
        _type = TCMessageTypeCompaniesRentBillGeneration;
    } else if ([homeMessageTypeEnum isEqualToString:@"COMPANIES_RENT_BILL_PAYMENT"]) {
        _type = TCMessageTypeCompaniesRentBillPayment;
    }
}

@end
