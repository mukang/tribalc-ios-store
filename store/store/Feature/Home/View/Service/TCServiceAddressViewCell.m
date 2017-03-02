//
//  TCServiceAddressViewCell.m
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceAddressViewCell.h"
#import "TCExtendButton.h"

@interface TCServiceAddressViewCell ()

@property (weak, nonatomic) TCExtendButton *phoneButton;
@property (weak, nonatomic) TCExtendButton *addressButton;
@property (weak, nonatomic) UIView *lineView;

@end

@implementation TCServiceAddressViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCRGBColor(42, 42, 42);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = TCRGBColor(42, 42, 42);
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:addressLabel];
    
    TCExtendButton *phoneButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"service_phone"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"service_phone"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(handleClickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    phoneButton.hitTestSlop = UIEdgeInsetsMake(-19, -15, -6, -15);
    [self.contentView addSubview:phoneButton];
    
    TCExtendButton *addressButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [addressButton setImage:[UIImage imageNamed:@"service_address"] forState:UIControlStateNormal];
    [addressButton setImage:[UIImage imageNamed:@"service_address"] forState:UIControlStateHighlighted];
    [addressButton addTarget:self action:@selector(handleClickAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    addressButton.hitTestSlop = UIEdgeInsetsMake(-6, -15, -19, -15);
    [self.contentView addSubview:addressButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    self.phoneLabel = phoneLabel;
    self.addressLabel = addressLabel;
    self.phoneButton = phoneButton;
    self.addressButton = addressButton;
    self.lineView = lineView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(19);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-50);
        make.height.mas_equalTo(16);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-19);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-50);
        make.height.mas_equalTo(16);
    }];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.phoneLabel);
    }];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.addressLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Actions

- (void)handleClickPhoneButton:(TCExtendButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPhoneButtonInServiceAddressViewCell:)]) {
        [self.delegate didClickPhoneButtonInServiceAddressViewCell:self];
    }
}

- (void)handleClickAddressButton:(TCExtendButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAddressButtonInServiceAddressViewCell:)]) {
        [self.delegate didClickAddressButtonInServiceAddressViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
