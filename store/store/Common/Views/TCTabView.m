//
//  TCTabView.m
//  property
//
//  Created by 王帅锋 on 16/12/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabView.h"

#define kBtnWidth 45.0

@interface TCTabView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation TCTabView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        if ([titleArr isKindOfClass:[NSArray class]]) {
            if (titleArr.count > 0) {
                CGFloat margn = (frame.size.width - titleArr.count * kBtnWidth - 20 * 2)/(titleArr.count - 1);
                for (int i = 0; i < titleArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake((kBtnWidth+margn)*i +20, 0, kBtnWidth, frame.size.height-2);
                    [self addSubview:btn];
                    [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:TCGrayColor forState:UIControlStateNormal];
                    btn.tag = 10000+i;
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//                    if (i == 0) {
//                        [self click:btn];
//                    }
                }
                _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, frame.size.height-2, kBtnWidth, 2)];
                [self addSubview:_lineView];
                _lineView.backgroundColor = TCRGBColor(88, 191, 200);
            }
        }
    }
    return self;
}

- (void)click:(UIButton *)btn {
    
    NSInteger i = btn.tag - 10000;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame), kBtnWidth, 2);
    }];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            NSInteger index = view.tag - 10000;
            if (index != i) {
                UIButton *button = (UIButton *)view;
                [button setTitleColor:TCGrayColor forState:UIControlStateNormal];
            }
        }
    }
    
    if (self.tapBlock) {
        self.tapBlock(i);
    }
}

@end
