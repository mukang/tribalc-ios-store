//
//  TCReservationInfoViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationInfoViewCell.h"

@implementation TCReservationInfoViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.textAlignment = NSTextAlignmentRight;
    subtitleLabel.textColor = TCBlackColor;
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
