//
//  TCTabBar.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabBar.h"

NSString *const TCVicinityButtonDidClickNotification = @"TCVicinityButtonDidClickNotification";

@interface TCTabBar ()

@property (weak, nonatomic) UIButton *vicinityButton;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.translucent = NO;
    
    UIButton *vicinityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vicinityButton setBackgroundImage:[UIImage imageNamed:@"tabBar_vicinity"] forState:UIControlStateNormal];
    [vicinityButton addTarget:self action:@selector(handleClickVicinityButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vicinityButton];
    self.vicinityButton = vicinityButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"附近";
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = TCRGBColor(112, 112, 112);
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}
/*
- (void)layoutSubviews {
    [super layoutSubviews];
//    TCLog(@"%@", [self.selectedItem titleTextAttributesForState:UIControlStateSelected]);
    CGFloat buttonW = self.width / 5.0;
    CGFloat buttonH = self.height;
    int buttonIndex = 0;
    
    for (UIView *childView in self.subviews) {
        if ([childView isKindOfClass:[UIControl class]] && ![childView isKindOfClass:[UIButton class]]) {
            CGFloat buttonX = buttonW * buttonIndex;
            childView.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
            buttonIndex ++;
            if (buttonIndex == 2) {
                buttonIndex ++;
            }
        }
    }
    CGFloat margin = 10;
    self.vicinityButton.size = self.vicinityButton.currentBackgroundImage.size;
    self.vicinityButton.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 15.6);
    self.titleLabel.center = CGPointMake(self.width * 0.5, CGRectGetMaxY(self.vicinityButton.frame) + margin);
}
 */

- (void)handleClickVicinityButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TCVicinityButtonDidClickNotification object:nil];
}

@end
