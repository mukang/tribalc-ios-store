//
//  TCStoreFeatureViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreFeatureViewCell.h"
#import "TCStoreFeature.h"

@interface TCStoreFeatureViewCell ()

@property (weak, nonatomic) UIView *bgView;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCStoreFeatureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 2.5;
    bgView.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    bgView.layer.borderWidth = 1;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (void)setFeature:(TCStoreFeature *)feature {
    self.titleLabel.text = feature.name;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    TCLog(@"-->%zd", selected);
}

@end
