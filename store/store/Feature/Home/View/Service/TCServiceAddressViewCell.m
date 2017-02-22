//
//  TCServiceAddressViewCell.m
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceAddressViewCell.h"

@interface TCServiceAddressViewCell ()

@property (weak, nonatomic) UIImageView *phoneImageView;
@property (weak, nonatomic) UIImageView *addressImageView;
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
    
    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"service_phone"]];
    [self.contentView addSubview:phoneImageView];
    
    UIImageView *addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"service_address"]];
    [self.contentView addSubview:addressImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    self.phoneLabel = phoneLabel;
    self.addressLabel = addressLabel;
    self.phoneImageView = phoneImageView;
    self.addressImageView = addressImageView;
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
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.phoneLabel);
    }];
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
