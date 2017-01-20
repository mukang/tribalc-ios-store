//
//  TCInfoViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCInfoViewCell.h"

@implementation TCInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    subtitleLabel.textColor = TCRGBColor(42, 42, 42);
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-30);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(120);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-30);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
