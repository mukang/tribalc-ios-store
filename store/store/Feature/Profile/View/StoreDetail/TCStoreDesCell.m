//
//  TCStoreDesCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDesCell.h"

@interface TCStoreDesCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *desLabel;

@end

@implementation TCStoreDesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setDes:(NSString *)des {
    if (_des != des) {
        _des = des;
        
        self.desLabel.text = des;
    }
}


- (void)setUpViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.desLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@45);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(45);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}


- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = TCGrayColor;
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.numberOfLines = 0;
        [_desLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];

    }
    return _desLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"介        绍:";
    }
    return _titleLabel;
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
