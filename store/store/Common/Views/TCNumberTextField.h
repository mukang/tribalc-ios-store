//
//  TCNumberTextField.h
//  individual
//
//  Created by 穆康 on 2017/6/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCNumberTextFieldDelegate;

/**
 输入数字类型的输入框
 */
@interface TCNumberTextField : UITextField

@property (weak, nonatomic) UIToolbar *toolBar;
@property (weak, nonatomic) id<TCNumberTextFieldDelegate> numDelegate;

@end


@protocol TCNumberTextFieldDelegate <NSObject>

@optional
- (void)didClickDoneItemInNumberTextField:(TCNumberTextField *)textField;

@end
