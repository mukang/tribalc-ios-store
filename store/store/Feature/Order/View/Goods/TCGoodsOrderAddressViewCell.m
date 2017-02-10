//
//  TCGoodsOrderAddressViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderAddressViewCell.h"

@interface TCGoodsOrderAddressViewCell ()

@property (weak, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *phoneLabel;
@property (weak, nonatomic) UIImageView *locationIcon;
@property (weak, nonatomic) UILabel *addressLabel;

@end

@implementation TCGoodsOrderAddressViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_order_address_bg"]];
    [self.contentView addSubview:bgImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCRGBColor(42, 42, 42);
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:phoneLabel];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_order_location"]];
    [self.contentView addSubview:locationIcon];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = TCRGBColor(42, 42, 42);
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.numberOfLines = 0;
    [self.contentView addSubview:addressLabel];
    
    self.bgImageView = bgImageView;
    self.nameLabel = nameLabel;
    self.phoneLabel = phoneLabel;
    self.locationIcon = locationIcon;
    self.addressLabel = addressLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(25);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.height.mas_equalTo(16);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(16);
    }];
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 13));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(16);
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(51);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(37);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(52);
    }];
}

- (void)setAddress:(NSString *)address {
    _address = address;
    
    NSArray *addressParts = [address componentsSeparatedByString:@"|"];
    if (addressParts.count == 3) {
        self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@", addressParts[0]];
        self.phoneLabel.text = addressParts[1];
        self.addressLabel.text = addressParts[2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
