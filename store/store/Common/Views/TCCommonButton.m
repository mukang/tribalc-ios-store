//
//  TCCommonButton.m
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonButton.h"
#import "UIImage+Category.h"

@implementation TCCommonButton

+ (instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self buttonWithTitle:title color:TCCommonButtonColorBlue target:target action:action];
}

+ (instancetype)buttonWithTitle:(NSString *)title color:(TCCommonButtonColor)color target:(id)target action:(SEL)action {
    TCCommonButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                }];
    [button setAttributedTitle:attTitle forState:UIControlStateNormal];
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    switch (color) {
        case TCCommonButtonColorBlue:
            normalImage = [UIImage imageWithColor:TCRGBColor(81, 199, 209)];
            highlightedImage = [UIImage imageWithColor:TCRGBColor(10, 164, 177)];
            break;
        case TCCommonButtonColorOrange:
            normalImage = [UIImage imageWithColor:TCRGBColor(252, 108, 38)];
            highlightedImage = [UIImage imageWithColor:TCRGBColor(236, 85, 11)];
            break;
            
        default:
            break;
    }
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.size = CGSizeMake(TCRealValue(315), 40);
    button.layer.cornerRadius = 2.5;
    button.layer.masksToBounds = YES;
    
    return button;
}

+ (instancetype)bottomButtonWithTitle:(NSString *)title color:(TCCommonButtonColor)color target:(id)target action:(SEL)action {
    TCCommonButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                }];
    [button setAttributedTitle:attTitle forState:UIControlStateNormal];
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    switch (color) {
        case TCCommonButtonColorBlue:
            normalImage = [UIImage imageWithColor:TCRGBColor(81, 199, 209)];
            highlightedImage = [UIImage imageWithColor:TCRGBColor(10, 164, 177)];
            break;
        case TCCommonButtonColorOrange:
            normalImage = [UIImage imageWithColor:TCRGBColor(252, 108, 38)];
            highlightedImage = [UIImage imageWithColor:TCRGBColor(236, 85, 11)];
            break;
            
        default:
            break;
    }
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.size = CGSizeMake(TCScreenWidth, 49);
    
    return button;
}

@end
