//
//  TCGoodsOrderGoodsViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderGoodsViewCell.h"
#import "TCGoodsOrderItem.h"
#import "TCGoods.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCGoodsOrderGoodsViewCell ()

@property (weak, nonatomic) UIImageView *goodsImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *standardLabel;
@property (weak, nonatomic) UILabel *amountLabel;

@end

@implementation TCGoodsOrderGoodsViewCell

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
    
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.clipsToBounds = YES;
    goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:goodsImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.numberOfLines = 2;
    [self.contentView addSubview:nameLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = TCBlackColor;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:priceLabel];
    
    UILabel *standardLabel = [[UILabel alloc] init];
    standardLabel.textColor = TCGrayColor;
    standardLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:standardLabel];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textColor = TCGrayColor;
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:amountLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self.contentView addSubview:lineView];
    
    self.goodsImageView = goodsImageView;
    self.nameLabel = nameLabel;
    self.priceLabel = priceLabel;
    self.standardLabel = standardLabel;
    self.amountLabel = amountLabel;
    self.lineView = lineView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 79));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(14);
        make.left.equalTo(weakSelf.goodsImageView.mas_right).with.offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-90);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(32);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
    [self.standardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-18);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.bottom.equalTo(weakSelf.standardLabel.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setOrderItem:(TCGoodsOrderItem *)orderItem {
    _orderItem = orderItem;
    
    TCGoods *goods = orderItem.goods;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goods.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(85, 79)];
    [self.goodsImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.nameLabel.text = goods.name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%0.2f", goods.salePrice];
    
    self.standardLabel.text = goods.standardSnapshot;
    
    self.amountLabel.text = [NSString stringWithFormat:@"×%zd", orderItem.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
