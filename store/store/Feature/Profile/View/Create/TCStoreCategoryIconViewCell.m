//
//  TCStoreCategoryIconViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreCategoryIconViewCell.h"
#import "TCStoreCategoryIconView.h"
#import "TCStoreCategoryInfo.h"

@interface TCStoreCategoryIconViewCell ()

@property (weak, nonatomic) TCStoreCategoryIconView *iconView;

@end

@implementation TCStoreCategoryIconViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    TCStoreCategoryIconView *iconView = [[TCStoreCategoryIconView alloc] init];
    iconView.layer.cornerRadius = TCRealValue(20);
    iconView.layer.borderWidth = 1;
    iconView.layer.borderColor = TCRGBColor(212, 212, 212).CGColor;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).with.insets(UIEdgeInsetsZero);
    }];
}

- (void)setCategoryInfo:(TCStoreCategoryInfo *)categoryInfo {
    _categoryInfo = categoryInfo;
    
    self.iconView.imageView.image = [UIImage imageNamed:categoryInfo.icon];
    self.iconView.titleLabel.text = categoryInfo.name;
}

@end
