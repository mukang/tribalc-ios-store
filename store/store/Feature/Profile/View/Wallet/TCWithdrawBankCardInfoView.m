//
//  TCWithdrawBankCardInfoView.m
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithdrawBankCardInfoView.h"
#import "TCBankCard.h"

@interface TCWithdrawBankCardInfoView ()

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *nameLabe;
@property (weak, nonatomic) UILabel *subtitleLabe;
@property (weak, nonatomic) UIImageView *arrowView;

@end

@implementation TCWithdrawBankCardInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.layer.cornerRadius = 12;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    
    UILabel *nameLabe = [[UILabel alloc] init];
    nameLabe.textColor = TCBlackColor;
    nameLabe.font = [UIFont systemFontOfSize:16];
    [self addSubview:nameLabe];
    
    UILabel *subtitleLabe = [[UILabel alloc] init];
    subtitleLabe.textColor = TCGrayColor;
    subtitleLabe.font = [UIFont systemFontOfSize:14];
    [self addSubview:subtitleLabe];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicating_arrow"]];
    [self addSubview:arrowView];
    
    self.logoImageView = logoImageView;
    self.nameLabe = nameLabe;
    self.subtitleLabe = subtitleLabe;
    self.arrowView = arrowView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf);
    }];
    [self.nameLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoImageView.mas_right).offset(14);
        make.top.equalTo(weakSelf).offset(12);
    }];
    [self.subtitleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabe);
        make.bottom.equalTo(weakSelf).offset(-12);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)setBankCard:(TCBankCard *)bankCard {
    _bankCard = bankCard;
    
    self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
    
    self.nameLabe.text = bankCard.bankName;
    
    NSString *tailNum;
    NSString *bankCardNum = bankCard.bankCardNum;
    if (bankCardNum.length >= 4) {
        tailNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
    }
    self.subtitleLabe.text = [NSString stringWithFormat:@"尾号%@储蓄卡", tailNum];
}



@end
