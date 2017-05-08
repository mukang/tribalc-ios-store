//
//  TCWithdrawAmountView.m
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithdrawAmountView.h"

@implementation TCWithdrawAmountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提现金额";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    
    UITextField *amountTextField = [[UITextField alloc] init];
    amountTextField.textColor = TCBlackColor;
    amountTextField.font = [UIFont systemFontOfSize:14];
    amountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入提现金额"
                                                                            attributes:@{
                                                                                         NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                         NSForegroundColorAttributeName: TCGrayColor
                                                                                         }];
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:amountTextField];
    self.amountTextField = amountTextField;
    
    __weak typeof(self) weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(75);
    }];
    [amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.right.equalTo(weakSelf).offset(-20);
        make.top.bottom.equalTo(weakSelf);
    }];
}

@end
