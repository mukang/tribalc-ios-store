//
//  TCReservationViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationViewCell.h"
#import "TCReservation.h"

#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

@interface TCReservationViewCell ()

@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *phoneLabel;
@property (weak, nonatomic) UILabel *timeTitleLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *numTitleLabel;
@property (weak, nonatomic) UILabel *numLabel;

@end

@implementation TCReservationViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:statusLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.layer.cornerRadius = 2.5;
    iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCRGBColor(42, 42, 42);
    phoneLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:phoneLabel];
    
    UILabel *timeTitleLabel = [[UILabel alloc] init];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.textColor = TCRGBColor(154, 154, 154);
    timeTitleLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:timeTitleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = TCRGBColor(42, 42, 42);
    timeLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:timeLabel];
    
    UILabel *numTitleLabel = [[UILabel alloc] init];
    numTitleLabel.text = @"人数";
    numTitleLabel.textColor = TCRGBColor(154, 154, 154);
    numTitleLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:numTitleLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = TCRGBColor(42, 42, 42);
    numLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:numLabel];
    
    self.statusLabel = statusLabel;
    self.lineView = lineView;
    self.iconImageView = iconImageView;
    self.nameLabel = nameLabel;
    self.phoneLabel = phoneLabel;
    self.timeTitleLabel = timeTitleLabel;
    self.timeLabel = timeLabel;
    self.numTitleLabel = numTitleLabel;
    self.numLabel = numLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.contentView.mas_top).with.offset(22.5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(45);
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(145, 115));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(13);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(22);
        make.left.equalTo(weakSelf.iconImageView.mas_right).with.offset(15);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
    }];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.equalTo(weakSelf.phoneLabel.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.equalTo(weakSelf.timeTitleLabel.mas_top);
        make.left.equalTo(weakSelf.timeTitleLabel.mas_right).with.offset(7);
    }];
    [self.numTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.equalTo(weakSelf.timeTitleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.nameLabel.mas_left);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.top.equalTo(weakSelf.numTitleLabel.mas_top);
        make.left.equalTo(weakSelf.numTitleLabel.mas_right).with.offset(7);
    }];
}

- (void)setReservation:(TCReservation *)reservation {
    _reservation = reservation;
    
    if ([reservation.status isEqualToString:@"SUCCEED"]) {
        self.statusLabel.text = @"预定成功";
        self.statusLabel.textColor = TCRGBColor(81, 199, 209);
    } else if ([reservation.status isEqualToString:@"FAILURE"]) {
        self.statusLabel.text = @"预定失败";
        self.statusLabel.textColor = TCRGBColor(154, 154, 154);
    } else if ([reservation.status isEqualToString:@"CANNEL"]) {
        self.statusLabel.text = @"预定取消";
        self.statusLabel.textColor = TCRGBColor(42, 42, 42);
    } else {
        self.statusLabel.text = @"预定申请";
        self.statusLabel.textColor = TCRGBColor(241, 68, 68);
    }
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:reservation.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(145, 115)];
    [self.iconImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.nameLabel.text = [NSString stringWithFormat:@"预订人 %@", reservation.linkman];
    
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话 %@", reservation.phone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:reservation.appointTime / 1000]]];
    
    self.numLabel.text = [NSString stringWithFormat:@"%zd", reservation.personNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
