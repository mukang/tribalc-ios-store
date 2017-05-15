//
//  TCWithdrawAmountView.h
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCWalletAccount;
@protocol TCWithdrawAmountViewDelegate;

@interface TCWithdrawAmountView : UIView

@property (strong, nonatomic)  TCWalletAccount *walletAccount;
@property (nonatomic) double enabledAmount;
@property (weak, nonatomic) UITextField *amountTextField;

@property (weak, nonatomic) id<TCWithdrawAmountViewDelegate> delegate;

@end


@protocol TCWithdrawAmountViewDelegate <NSObject>

@optional
- (void)didClickAllWithdrawButtonInWithdrawAmountView:(TCWithdrawAmountView *)view;

@end
