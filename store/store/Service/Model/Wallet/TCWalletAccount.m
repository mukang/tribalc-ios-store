//
//  TCWalletAccount.m
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletAccount.h"
#import "TCBankCard.h"

@implementation TCWalletAccount

+ (NSDictionary *)objectClassInArray {
    return @{@"bankCards": [TCBankCard class]};
}

@end
