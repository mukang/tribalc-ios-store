//
//  TCForceUpdateView.m
//  individual
//
//  Created by 穆康 on 2017/5/31.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCForceUpdateView.h"

#import "TCAppVersion.h"

#import <TCCommonButton.h>

@interface TCForceUpdateView ()

@property (weak, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) UILabel *titlelabel;
@property (weak, nonatomic) UILabel *messageLabel;
@property (weak, nonatomic) TCCommonButton *updateButton;

@end

@implementation TCForceUpdateView

- (instancetype)initWithVersionInfo:(TCAppVersion *)versionInfo {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _versionInfo = versionInfo;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"force_update_bg"];
    [self addSubview:bgImageView];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.text = @"发现新版本";
    titlelabel.textColor = TCBlackColor;
    titlelabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:titlelabel];
    
    NSString *message = nil;
    NSArray *messageList = _versionInfo.releaseNote;
    if (messageList.count) {
        message = [messageList componentsJoinedByString:@"\n"];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 10.0;
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:message
                                                                  attributes:@{
                                                                               NSForegroundColorAttributeName: TCBlackColor,
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                               NSParagraphStyleAttributeName: paragraphStyle
                                                                               }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.attributedText = attText;
    messageLabel.numberOfLines = 0;
    [self addSubview:messageLabel];
    
    TCCommonButton *updateButton = [TCCommonButton buttonWithTitle:@"立即更新" target:self action:@selector(handleClickUpdateButotn:)];
    [self addSubview:updateButton];
    
    self.bgImageView = bgImageView;
    self.titlelabel = titlelabel;
    self.messageLabel = messageLabel;
    self.updateButton = updateButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(112);
        make.centerX.equalTo(weakSelf);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(158);
        make.left.equalTo(weakSelf).offset(23);
        make.right.equalTo(weakSelf).offset(-23);
        make.bottom.lessThanOrEqualTo(weakSelf).offset(-103);
    }];
    [self.messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(23);
        make.right.equalTo(weakSelf).offset(-23);
        make.bottom.equalTo(weakSelf).offset(-14);
        make.height.mas_equalTo(38);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(284);
        make.height.mas_greaterThanOrEqualTo(330);
    }];
}


- (void)handleClickUpdateButotn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickUpdateButtonInForceUpdateView:)]) {
        [self.delegate didClickUpdateButtonInForceUpdateView:self];
    }
}

@end
