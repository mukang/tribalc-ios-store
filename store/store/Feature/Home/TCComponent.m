//
//  TCComponent.m
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCComponent.h"

@implementation TCComponent

+ (UILabel *)createLabelWithText:(NSString *)text AndFontSize:(float)font{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    [label sizeToFit];
    
    return label;
}

+ (UILabel *)createLabelWithText:(NSString *)text AndFontSize:(float)font AndTextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    [label sizeToFit];
    
    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

+ (UILabel *)createCenterLabWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text {
    UILabel *label =[TCComponent createLabelWithFrame:frame AndFontSize:font AndTitle:text];
    label.textAlignment = NSTextAlignmentCenter;

    return label;


}

+ (UILabel *)createLabelWithFrame:(CGRect)frame AndFontSize:(float)font AndTitle:(NSString *)text AndTextColor:(UIColor *)color{
    UILabel *label = [TCComponent createLabelWithFrame:frame AndFontSize:font AndTitle:text];
    label.textColor = color;

    return label;
}

+ (UIView *)createGrayLineWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    
    return view;
}

+ (UIButton *)createImageBtnWithFrame:(CGRect)frame AndImageName:(NSString *)imgName {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame AndTitle:(NSString *)title AndFontSize:(float)font {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame AndTitle:(NSString *)title AndFontSize:(float)font AndBackColor:(UIColor *)backColor AndTextColor:(UIColor *)titleColor {
    UIButton *button = [TCComponent createButtonWithFrame:frame AndTitle:title AndFontSize:font];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.backgroundColor = backColor;
    
    return button;
}

+ (UIWebView *)callWithPhone:(NSString *)phoneStr {
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *callStr = [NSString stringWithFormat:@"tel:%@", phoneStr];
    NSURL *telURL =[NSURL URLWithString:callStr];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    return callWebview;
}

@end
