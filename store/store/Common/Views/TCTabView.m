//
//  TCTabView.m
//  property
//
//  Created by 王帅锋 on 16/12/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabView.h"
#import "TCDefines.h"
#import "TCTabButton.h"

#define kBtnWidth 55.0

@interface TCTabView ()

@property (nonatomic, strong) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *allButtons;

@end

@implementation TCTabView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        if ([titleArr isKindOfClass:[NSArray class]]) {
            if (titleArr.count > 0) {
                CGFloat margn = (frame.size.width - titleArr.count * kBtnWidth - 10 * 2)/(titleArr.count - 1);
                for (int i = 0; i < titleArr.count; i++) {
                    TCTabButton *btn = [TCTabButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake((kBtnWidth+margn)*i +10, 0, kBtnWidth, frame.size.height-2);
                    [self addSubview:btn];
                    [self.allButtons addObject:btn];
                    [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:TCGrayColor forState:UIControlStateNormal];
                    btn.tag = 10000+i;
                    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                }
                _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, frame.size.height-2, kBtnWidth, 2)];
                [self addSubview:_lineView];
                _lineView.backgroundColor = TCRGBColor(88, 191, 200);
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUnreadNum:) name:@"TCClearUnreadNum" object:nil];
        }
    }
    return self;
}

- (void)setUnreadNumDic:(NSDictionary *)unreadNumDic {
    
    if (![unreadNumDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _unreadNumDic = unreadNumDic;
    NSDictionary *dic = unreadNumDic[@"messageTypeCount"];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSNumber *num = dic[@"ORDER_SETTLE"];
        if ([num isKindOfClass:[NSNumber class]]) {
            TCTabButton *tabBtn = self.allButtons[2];
            tabBtn.num = num;
        }
    }
}

- (void)selectIndex:(NSUInteger)index {
    if (self.allButtons.count > index) {
        TCTabButton *button = self.allButtons[index];
        [self click:button];
    }
}

- (void)clearUnreadNum:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSNumber *num = dic[@"index"];
        NSString *type = dic[@"type"];
        if ([num isKindOfClass:[NSNumber class]] && [type isKindOfClass:[NSString class]]) {
            [self clearUnReadNumWithBtnWithIndex:[num integerValue] type:type];
        }
    }
}

- (void)clearUnReadNumWithBtnWithIndex:(NSInteger)index type:(NSString *)type {
    if (index > 0 && index < self.allButtons.count) {
        TCTabButton *btn = self.allButtons[index];
        [self clearUnReadNumWithBtn:btn type:type];
    }
}


- (void)clearUnReadNumWithBtn:(TCTabButton *)btn type:(NSString *)type {
    NSNumber *number = btn.num;
    if ([number isKindOfClass:[NSNumber class]] && [type isKindOfClass:[NSString class]]) {
        if ([number integerValue] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TCSubtractCurrentUnReadNum" object:nil userInfo:@{@"unreadNum":number,@"type":type}];
            btn.num = @0;
        }
    }
}

- (void)click:(TCTabButton *)btn {
    
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

#pragma mark - Override Methods

- (NSMutableArray *)allButtons {
    if (_allButtons == nil) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}

@end
