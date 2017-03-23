//
//  TCStoreCategoryIconView.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreCategoryIconView.h"

@implementation TCStoreCategoryIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(26), TCRealValue(29)));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).with.offset(TCRealValue(-8));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(60), TCRealValue(14)));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).with.offset(TCRealValue(14));
    }];
}

@end
