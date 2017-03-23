//
//  TCStoreSearchAddressViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreSearchAddressViewCell.h"
#import "TCCommonButton.h"

@interface TCStoreSearchAddressViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCCommonButton *searchButton;

@end

@implementation TCStoreSearchAddressViewCell

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"详细地址";
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:14];
    textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    TCCommonButton *searchButton = [TCCommonButton buttonWithTitle:@"搜索" color:TCCommonButtonColorOrange target:self action:@selector(handleClickSearchButton:)];
    [searchButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"搜索"
                                                                     attributes:@{
                                                                                  NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                  NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                  }]
                            forState:UIControlStateNormal];
    [self.contentView addSubview:searchButton];
    self.searchButton = searchButton;
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
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-80);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)handleClickSearchButton:(UIButton *)sender {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(storeSearchAddressViewCell:didClickSearchButtonWithAddress:)]) {
        [self.delegate storeSearchAddressViewCell:self didClickSearchButtonWithAddress:self.textField.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
