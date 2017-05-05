//
//  TCWithdrawViewController.h
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCWalletAccount;

typedef void(^TCWithdrawCompletionBlock)();

@interface TCWithdrawViewController : TCBaseViewController


@property (strong, nonatomic, readonly) TCWalletAccount *walletAccount;
/** 提现完成的回调 */
@property (copy, nonatomic) TCWithdrawCompletionBlock completionBlock;


- (instancetype)initWithWalletAccount:(TCWalletAccount *)walletAccount;

@end
