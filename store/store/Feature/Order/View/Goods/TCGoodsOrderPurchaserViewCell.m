//
//  TCGoodsOrderPurchaserViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderPurchaserViewCell.h"

@implementation TCGoodsOrderPurchaserViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    
    self.iconView = iconView;
    self.nameLabel = nameLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.equalTo(weakSelf.iconView.mas_right).with.offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
