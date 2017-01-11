//
//  TCComponent.h
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOLD_FONT   @"Helvetica-Bold"

@interface TCComponent : NSObject
+ (UILabel *)createLabelWithText:(NSString *)text AndFontSize:(float)font;
+ (UILabel *)createLabelWithText:(NSString *)text AndFontSize:(float)font AndTextColor:(UIColor *)color;
+ (UILabel *)createCenterLabWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text;
+ (UILabel *)createLabelWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text;
+ (UILabel *)createLabelWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text AndTextColor:(UIColor *)color;
+ (UIView *)createGrayLineWithFrame:(CGRect)frame;
+ (UIButton *)createImageBtnWithFrame:(CGRect)frame AndImageName:(NSString *)imgName;
+ (UIButton *)createButtonWithFrame:(CGRect)frame AndTitle:(NSString *)title AndFontSize:(float)font AndBackColor:(UIColor *)backColor AndTextColor:(UIColor *)titleColor;
+ (UIButton *)createButtonWithFrame:(CGRect)frame AndTitle:(NSString *)title AndFontSize:(float)font;

+ (UIWebView *)callWithPhone:(NSString *)phoneStr;

@end
