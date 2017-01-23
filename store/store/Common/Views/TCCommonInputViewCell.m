//
//  TCCommonInputViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonInputViewCell.h"

@interface TCCommonInputViewCell () <UITextFieldDelegate>

@end

@implementation TCCommonInputViewCell

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = TCRGBColor(42, 42, 42);
    textField.font = [UIFont systemFontOfSize:14];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.textField.mas_left);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(100);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                           attributes:@{
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                        NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                                        }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(commonInputViewCell:textFieldDidEndEditing:)]) {
        [self.delegate commonInputViewCell:self textFieldDidEndEditing:self.textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(commonInputViewCell:textFieldShouldReturn:)]) {
        return [self.delegate commonInputViewCell:self textFieldShouldReturn:self.textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(commonInputViewCell:textFieldShouldBeginEditing:)]) {
        return [self.delegate commonInputViewCell:self textFieldShouldBeginEditing:self.textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[textField textInputMode] primaryLanguage] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

@end
