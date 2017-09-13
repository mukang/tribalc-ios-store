//
//  TCBankCard.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankCard.h"

@implementation TCBankCard

- (void)setBindType:(NSString *)bindType {
    _bindType = bindType;
    
    if ([bindType isEqualToString:@"NORMAL"]) {
        self.type = TCBankCardTypeNormal;
    } else if ([bindType isEqualToString:@"WITHDRAW"]) {
        self.type = TCBankCardTypeWithdraw;
    }
}

@end
