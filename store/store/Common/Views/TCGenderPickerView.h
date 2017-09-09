//
//  TCGenderPickerView.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCGenderPickerView;

@protocol TCGenderPickerViewDelegate <NSObject>

@optional
- (void)genderPickerView:(TCGenderPickerView *)view didClickConfirmButtonWithGender:(NSString *)gender;

@end

@interface TCGenderPickerView : UIView

@property (weak, nonatomic) id<TCGenderPickerViewDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;

@end
