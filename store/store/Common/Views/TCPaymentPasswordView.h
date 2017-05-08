//
//  TCPaymentPasswordView.h
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBPasswordTextField.h"
@class TCPaymentPasswordView;

@protocol TCPaymentPasswordViewDelegate <NSObject>

@optional
- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password;
- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view;

@end

@interface TCPaymentPasswordView : UIView

@property (weak, nonatomic) MLBPasswordTextField *textField;

@property (weak, nonatomic) id<TCPaymentPasswordViewDelegate> delegate;

@end
