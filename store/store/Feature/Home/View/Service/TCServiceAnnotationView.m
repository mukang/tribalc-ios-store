//
//  TCServiceAnnotationView.m
//  store
//
//  Created by 穆康 on 2017/2/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceAnnotationView.h"

@implementation TCServiceAnnotationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(handleClickInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    self.rightCalloutAccessoryView = infoButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.equalTo(weakSelf.mas_right);
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)handleClickInfoButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickInfoButtonInServiceAnnotationView:)]) {
        [self.delegate didClickInfoButtonInServiceAnnotationView:self];
    }
}

@end
