//
//  TCServiceTabItemView.m
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceTabItemView.h"

@interface TCServiceTabItemView ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation TCServiceTabItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selected = NO;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"service_down_arrow"];
    [self addSubview:imageView];
    
    self.titleLabel = titleLabel;
    self.imageView = imageView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).offset(2);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-2);
        make.right.equalTo(weakSelf.imageView.mas_left).offset(-3);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14.5, 8));
        make.right.centerY.equalTo(weakSelf);
    }];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (selected) {
        self.titleLabel.textColor = TCRGBColor(80, 199, 209);
        self.imageView.image = [UIImage imageNamed:@"service_up_arrow"];
    } else {
        self.titleLabel.textColor = TCBlackColor;
        self.imageView.image = [UIImage imageNamed:@"service_down_arrow"];
    }
}

@end
