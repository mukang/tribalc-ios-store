//
//  TCWithdrawAmountView.m
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithdrawAmountView.h"

#import <TCCommonLibs/TCExtendButton.h>

#import "TCWalletAccount.h"

@interface TCWithdrawAmountView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *symbolLabel;
@property (weak, nonatomic) UILabel *enabledAmountLabel;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) TCExtendButton *allWithdrawButton;

@end

@implementation TCWithdrawAmountView

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    
    UILabel *symbolLabel = [[UILabel alloc] init];
    symbolLabel.text = @"¥";
    symbolLabel.textColor = TCBlackColor;
    symbolLabel.font = [UIFont boldSystemFontOfSize:30];
    [symbolLabel sizeToFit];
    [self addSubview:symbolLabel];
    
    UITextField *amountTextField = [[UITextField alloc] init];
    amountTextField.textColor = TCBlackColor;
    amountTextField.font = [UIFont boldSystemFontOfSize:30];
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    amountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:amountTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    UILabel *enabledAmountLabel = [[UILabel alloc] init];
    enabledAmountLabel.textColor = TCGrayColor;
    enabledAmountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:enabledAmountLabel];
    
    TCExtendButton *allWithdrawButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [allWithdrawButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"全部提现"
                                                                          attributes:@{
                                                                                       NSForegroundColorAttributeName: TCRGBColor(81, 199, 209),
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                                                       }]
                                 forState:UIControlStateNormal];
    [allWithdrawButton addTarget:self
                          action:@selector(handleClickAllWithdrawButton:)
                forControlEvents:UIControlEventTouchUpInside];
    allWithdrawButton.hitTestSlop = UIEdgeInsetsMake(-5, -20, -5, -20);
    [self addSubview:allWithdrawButton];
    
    
    self.titleLabel = titleLabel;
    self.symbolLabel = symbolLabel;
    self.amountTextField = amountTextField;
    self.lineView = lineView;
    self.enabledAmountLabel = enabledAmountLabel;
    self.allWithdrawButton = allWithdrawButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf.mas_top).offset(15);
    }];
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(20);
    }];
    [self.symbolLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                        forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.symbolLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.symbolLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.bottom.equalTo(weakSelf).offset(-34);
        make.height.mas_equalTo(0.5);
    }];
    [self.enabledAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf.lineView.mas_bottom).offset(17);
    }];
    [self.allWithdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.lineView.mas_bottom).offset(17);
    }];
}

#pragma mark - Actions

- (void)handleClickAllWithdrawButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAllWithdrawButtonInWithdrawAmountView:)]) {
        [self.delegate didClickAllWithdrawButtonInWithdrawAmountView:self];
    }
}

#pragma mark - Override Methods

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    self.titleLabel.text = [NSString stringWithFormat:@"提现金额（收取%0.2f元服务费）", walletAccount.withdrawCharge];
}

- (void)setEnabledAmount:(double)enabledAmount {
    _enabledAmount = enabledAmount;
    
    NSString *enabledAmountStr = [NSString stringWithFormat:@"%0.2f", self.enabledAmount];
    NSString *str = [NSString stringWithFormat:@"可转出金额：%@元", enabledAmountStr];
    NSRange highlightRange = [str rangeOfString:enabledAmountStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                               attributes:@{
                                                                                            NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                            NSForegroundColorAttributeName: TCGrayColor
                                                                                            }];
    [attStr addAttribute:NSForegroundColorAttributeName value:TCRGBColor(229, 16, 16) range:highlightRange];
    self.enabledAmountLabel.attributedText = attStr;
}

@end
