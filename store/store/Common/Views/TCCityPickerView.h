//
//  TCCityPickerView.h
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCCityPickerViewDelegate;

extern NSString *const TCCityPickierViewProvinceKey;
extern NSString *const TCCityPickierViewCityKey;
extern NSString *const TCCityPickierViewCountryKey;

@interface TCCityPickerView : UIView

@property (weak, nonatomic) id<TCCityPickerViewDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;

@end

@protocol TCCityPickerViewDelegate <NSObject>

@optional
- (void)cityPickerView:(TCCityPickerView *)view didClickConfirmButtonWithCityInfo:(NSDictionary *)cityInfo;
@end
