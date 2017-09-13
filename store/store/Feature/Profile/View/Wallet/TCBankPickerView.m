//
//  TCBankPickerView.m
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankPickerView.h"

@interface TCBankPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation TCBankPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.banks.count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 60)];
    
    TCBankCard *bankCard = self.banks[row];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = bankCard.bankName;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [containerView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"该银行卡只能用于提现";
    subTitleLabel.textColor = TCBlackColor;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:subTitleLabel];
    subTitleLabel.hidden = bankCard.maxPaymentAmount;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(containerView);
    }];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView);
        make.centerY.equalTo(containerView).offset(20);
    }];
    
    return containerView;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = self.banks[row];
    return [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                         NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                         }];
}

#pragma mark - Actions

- (IBAction)handleClickConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bankPickerView:didClickConfirmButtonWithBankCard:)]) {
        TCBankCard *bankCard = [self getCurrentSelectedInfo];
        [self.delegate bankPickerView:self didClickConfirmButtonWithBankCard:bankCard];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBankPickerView:)]) {
        [self.delegate didClickCancelButtonInBankPickerView:self];
    }
}

#pragma mark - Get Current Info

- (TCBankCard *)getCurrentSelectedInfo {
    NSInteger currentIndex = [self.pickerView selectedRowInComponent:0];
    return self.banks[currentIndex];
}

@end
