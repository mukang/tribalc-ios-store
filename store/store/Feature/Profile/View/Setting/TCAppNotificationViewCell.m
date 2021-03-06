//
//  TCAppNotificationViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppNotificationViewCell.h"

@interface TCAppNotificationViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UISwitch *switchButton;

@end

@implementation TCAppNotificationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"消息推送";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [switchButton addTarget:self action:@selector(handleChangeSwitchButton:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
    self.switchButton = switchButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.width.mas_equalTo(100);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)handleChangeSwitchButton:(UISwitch *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息通知" message:@"如果你要关闭或开启部落公社的新消息通知，请在设备的“设置”-“通知中心”功能中，找到应用程序“部落公社”进行修改。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
