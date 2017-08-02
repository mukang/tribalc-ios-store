//
//  TCHomeMessageMoneyMiddleCell.m
//  individual
//
//  Created by 王帅锋 on 2017/8/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageMoneyMiddleCell.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import "TCHomeMessage.h"

@interface TCHomeMessageMoneyMiddleCell ()

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *moneyDesLabel;

@property (strong, nonatomic) UILabel *moneySubTitleLabel;

@end

@implementation TCHomeMessageMoneyMiddleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    [super setHomeMessage:homeMessage];
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:homeMessage.messageBody.avatar needTimestamp:NO];
    [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    self.moneyLabel.text = homeMessage.messageBody.body;
    self.moneyDesLabel.text = homeMessage.messageBody.desc;
    if (homeMessage.messageBody.applicationTime) {
        self.moneySubTitleLabel.text = [NSString stringWithFormat:@"申请日期:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.messageBody.applicationTime/1000]]];
    }else {
        self.moneySubTitleLabel.text = nil;
    }

}

- (void)setUpSubViews {
    
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@102);
    }];
    
    [self.middleView addSubview:self.iconImageView];
    [self.middleView addSubview:self.moneyLabel];
    [self.middleView addSubview:self.moneyDesLabel];
    [self.middleView addSubview:self.moneySubTitleLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleView);
        make.width.height.equalTo(@56);
        make.left.equalTo(self.middleView).offset(TCRealValue(60));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(TCRealValue(30));
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self.middleView).offset(-20);
        make.height.equalTo(@33);
    }];
    
    [self.moneyDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.right.equalTo(self.moneyLabel);
    }];
    
    [self.moneySubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.moneyDesLabel);
        make.top.equalTo(self.moneyDesLabel.mas_bottom).offset(5);
    }];
}



- (UILabel *)moneySubTitleLabel {
    if (_moneySubTitleLabel == nil) {
        _moneySubTitleLabel = [[UILabel alloc] init];
        _moneySubTitleLabel.textColor = TCGrayColor;
        _moneySubTitleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _moneySubTitleLabel;
}

- (UILabel *)moneyDesLabel {
    if (_moneyDesLabel == nil) {
        _moneyDesLabel = [[UILabel alloc] init];
        _moneyDesLabel.textColor = TCBlackColor;
        _moneyDesLabel.font = [UIFont systemFontOfSize:12];
        _moneyDesLabel.numberOfLines = 0;
    }
    return _moneyDesLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:32];
    }
    return _moneyLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 28;
    }
    return _iconImageView;
}

@end
