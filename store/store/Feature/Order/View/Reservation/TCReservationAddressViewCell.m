//
//  TCReservationAddressViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationAddressViewCell.h"

@implementation TCReservationAddressViewCell

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textAlignment = NSTextAlignmentRight;
    addressLabel.textColor = TCBlackColor;
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.numberOfLines = 0;
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(12);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_top);
        make.left.equalTo(weakSelf.titleLabel.mas_right).with.offset(34);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
