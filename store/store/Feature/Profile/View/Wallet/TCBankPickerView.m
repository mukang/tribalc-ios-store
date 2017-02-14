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
@property (strong, nonatomic) NSArray *banks;

@end

@implementation TCBankPickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadData];
    
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

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = self.banks[row];
    return [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                         NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                         }];
}

#pragma mark - Actions

- (IBAction)handleClickConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bankPickerView:didClickConfirmButtonWithBankName:)]) {
        NSString *bankName = [self getCurrentSelectedInfo];
        [self.delegate bankPickerView:self didClickConfirmButtonWithBankName:bankName];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBankPickerView:)]) {
        [self.delegate didClickCancelButtonInBankPickerView:self];
    }
}

#pragma mark - Get Current Info

- (NSString *)getCurrentSelectedInfo {
    NSInteger currentIndex = [self.pickerView selectedRowInComponent:0];
    return self.banks[currentIndex];
}

#pragma mark - Load Data

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bankCard" ofType:@"plist"];
    NSDictionary *banksDic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.banks = banksDic.allKeys;
}

@end
