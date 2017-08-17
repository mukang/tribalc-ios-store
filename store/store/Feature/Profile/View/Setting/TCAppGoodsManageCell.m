//
//  TCAppGoodsManageCell.m
//  store
//
//  Created by 王帅锋 on 2017/8/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppGoodsManageCell.h"
#import "TCBuluoApi.h"
#import "TCUserDefaultsKeys.h"

@interface TCAppGoodsManageCell ()

@property (weak, nonatomic) UILabel *titleLabel;

@property (weak, nonatomic) UISwitch *switchButton;

@end

@implementation TCAppGoodsManageCell

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
    titleLabel.text = @"线上模式";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [switchButton addTarget:self action:@selector(handleChangeSwitchButton:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
    NSValue *value = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchGoodManage];
    if ([value isEqualToValue:@YES]) {
        switchButton.on = YES;
    }
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:TCUserDefaultsKeySwitchGoodManage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TCDidUpdateGoodsManageControl" object:nil userInfo:@{@"isGoodManage":@(sender.on)}];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
