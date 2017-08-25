//
//  TCMessageManagementViewCell.m
//  individual
//
//  Created by 穆康 on 2017/8/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMessageManagementViewCell.h"
#import "TCMessageManagement.h"

@interface TCMessageManagementViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UISwitch *switchButton;

@end

@implementation TCMessageManagementViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [switchButton addTarget:self action:@selector(handleClickSwitchButton:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
    self.switchButton = switchButton;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setMessageManagement:(TCMessageManagement *)messageManagement {
    _messageManagement = messageManagement;
    
    self.titleLabel.text = messageManagement.messageTypeView.homeMessageType;
    self.switchButton.on = messageManagement.isOpen;
}

- (void)handleClickSwitchButton:(UISwitch *)switchButton {
    if ([self.delegate respondsToSelector:@selector(messageManagementViewCell:didClickSwitchButtonWithType:open:)]) {
        [self.delegate messageManagementViewCell:self
                    didClickSwitchButtonWithType:self.messageManagement.messageTypeView.homeMessageTypeEnum
                                            open:switchButton.isOn];
    }
}

@end
