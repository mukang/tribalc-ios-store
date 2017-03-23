//
//  TCCommonSwitchViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonSwitchViewCell.h"

@implementation TCCommonSwitchViewCell

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
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UISwitch *switchControl = [[UISwitch alloc] init];
    [switchControl addTarget:self action:@selector(handleChangeSwitchControl:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchControl];
    self.switchControl = switchControl;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
}

- (void)handleChangeSwitchControl:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(commonSwitchViewCell:didChangeSwitchControlWithOn:)]) {
        [self.delegate commonSwitchViewCell:self didChangeSwitchControlWithOn:sender.isOn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
