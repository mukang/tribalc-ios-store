//
//  TCBankPickerView.h
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBankCard.h"

@class TCBankPickerView;

@protocol TCBankPickerViewDelegate <NSObject>

@optional
- (void)bankPickerView:(TCBankPickerView *)view didClickConfirmButtonWithBankCard:(TCBankCard *)bankCard;
- (void)didClickCancelButtonInBankPickerView:(TCBankPickerView *)view;

@end

@interface TCBankPickerView : UIView

@property (strong, nonatomic) NSArray *banks;
@property (weak, nonatomic) id<TCBankPickerViewDelegate> delegate;

@end
