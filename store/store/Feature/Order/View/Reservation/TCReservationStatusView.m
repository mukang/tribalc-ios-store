//
//  TCReservationStatusView.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationStatusView.h"

@interface TCReservationStatusView ()

@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UILabel *noteLabel;

@end

@implementation TCReservationStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCBackgroundColor;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = TCBlackColor;
    statusLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:statusLabel];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = TCGrayColor;
    noteLabel.font = [UIFont boldSystemFontOfSize:14];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noteLabel];
    
    self.iconImageView = iconImageView;
    self.statusLabel = statusLabel;
    self.noteLabel = noteLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.equalTo(weakSelf.mas_top).with.offset(22);
        make.left.equalTo(weakSelf.mas_left).with.offset(TCRealValue(140));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(3);
        make.centerY.equalTo(weakSelf.iconImageView.mas_centerY);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).with.offset(9);
        make.left.equalTo(weakSelf.mas_left).with.offset(TCRealValue(20));
        make.right.equalTo(weakSelf.mas_right).with.offset(TCRealValue(-20));
    }];
}

- (void)setStatus:(NSString *)status {
    _status = status;
    
    self.noteLabel.hidden = NO;
    if ([status isEqualToString:@"SUCCEED"]) {
        self.statusLabel.text = @"预定完成";
        self.noteLabel.text = @"餐厅已按预约人的要求保留座位";
        self.iconImageView.image = [UIImage imageNamed:@"reservation_status_succeed"];
    } else if ([status isEqualToString:@"FAILURE"]) {
        self.statusLabel.text = @"预定失败";
        self.noteLabel.text = @"餐厅未能按照指定要求保留座位";
        self.iconImageView.image = [UIImage imageNamed:@"reservation_status_failure"];
    } else if ([status isEqualToString:@"CANNEL"]) {
        self.statusLabel.text = @"预定取消";
        self.noteLabel.hidden = YES;
        self.iconImageView.image = [UIImage imageNamed:@"reservation_status_cancel"];
    } else {
        self.statusLabel.text = @"预定处理中";
        self.noteLabel.text = @"订单结果会通过推送的方式告知预约人";
        self.iconImageView.image = [UIImage imageNamed:@"reservation_status_processing"];
    }
}

@end
