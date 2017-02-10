//
//  TCGoodsOrderViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderViewCell.h"
#import "TCGoodsOrderItem.h"
#import "TCGoods.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

@interface TCGoodsOrderViewCell ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *brandLabel;
@property (weak, nonatomic) UILabel *accountLabel;
@property (weak, nonatomic) UILabel *purchaserLabel;

@end

@implementation TCGoodsOrderViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = TCRGBColor(242, 242, 242);
    [self.contentView addSubview:containerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:nameLabel];
    
    UILabel *brandLabel = [[UILabel alloc] init];
    brandLabel.textColor = TCRGBColor(42, 42, 42);
    brandLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:brandLabel];
    
    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.textColor = TCRGBColor(42, 42, 42);
    accountLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:accountLabel];
    
    UILabel *purchaserLabel = [[UILabel alloc] init];
    purchaserLabel.textColor = TCRGBColor(154, 154, 154);
    purchaserLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:purchaserLabel];
    
    self.containerView = containerView;
    self.imageView = imageView;
    self.nameLabel = nameLabel;
    self.brandLabel = brandLabel;
    self.accountLabel = accountLabel;
    self.purchaserLabel = purchaserLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.containerView.mas_top).with.offset(3);
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(3);
        make.bottom.equalTo(weakSelf.containerView.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(136);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.containerView.mas_top).with.offset(12);
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(12);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-12);
        make.height.mas_equalTo(14);
    }];
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(4);
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(12);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-12);
        make.height.mas_equalTo(14);
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.containerView.mas_bottom).with.offset(-30);
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(12);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-12);
        make.height.mas_equalTo(14);
    }];
    [self.purchaserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.accountLabel.mas_bottom).with.offset(4);
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(12);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-12);
        make.height.mas_equalTo(14);
    }];
}

- (void)setAccount:(NSString *)account {
    _account = account;
    
    NSString *titleStr = @"账号：";
    NSString *accountStr = [NSString stringWithFormat:@"%@%@", titleStr, account];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:accountStr];
    NSRange titleRange = [accountStr rangeOfString:titleStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:TCRGBColor(154, 154, 154) range:titleRange];
    self.accountLabel.attributedText = attStr;
}

- (void)setPurchaser:(NSString *)purchaser {
    _purchaser = purchaser;
    
    self.purchaserLabel.text = [NSString stringWithFormat:@"购买人：%@", purchaser];
}

- (void)setOrderItem:(TCGoodsOrderItem *)orderItem {
    _orderItem = orderItem;
    
    TCGoods *goods = orderItem.goods;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goods.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(136, 103)];
    [self.imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.nameLabel.text = goods.name;
    
    self.brandLabel.text = goods.brand;
}

@end
