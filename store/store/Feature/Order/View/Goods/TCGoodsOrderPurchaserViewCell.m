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
    iconView.layer.cornerRadius = 20;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self.contentView addSubview:lineView];
    
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.lineView = lineView;
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
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
