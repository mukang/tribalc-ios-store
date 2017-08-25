//
//  TCTabButton.m
//  store
//
//  Created by 王帅锋 on 2017/8/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabButton.h"

@interface TCTabButton ()

@property (weak, nonatomic) UILabel *unReadNumLabel;

@end

@implementation TCTabButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    UILabel *unReadNumLabel = [[UILabel alloc] init];
    unReadNumLabel.textAlignment = NSTextAlignmentCenter;
    unReadNumLabel.textColor = [UIColor whiteColor];
    unReadNumLabel.backgroundColor = [UIColor redColor];
    unReadNumLabel.font = [UIFont systemFontOfSize:10];
    unReadNumLabel.layer.cornerRadius = 6;
    unReadNumLabel.clipsToBounds = YES;
    unReadNumLabel.hidden = YES;
    [self addSubview:unReadNumLabel];
    self.unReadNumLabel = unReadNumLabel;
    
    [unReadNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(1);
        make.height.equalTo(@12);
        make.width.mas_greaterThanOrEqualTo(@12);
    }];
}

- (void)setNum:(NSNumber *)num {
    if ([num isKindOfClass:[NSNumber class]]) {
        _num = num;
        if ([num integerValue]) {
            self.unReadNumLabel.text = [NSString stringWithFormat:@"%d",[num integerValue]];
            self.unReadNumLabel.hidden = NO;
        }else {
            self.unReadNumLabel.hidden = YES;
        }
    }else {
        self.unReadNumLabel.hidden = YES;
    }
}

@end
