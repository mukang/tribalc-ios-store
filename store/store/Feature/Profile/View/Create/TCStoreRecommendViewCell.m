//
//  TCStoreRecommendViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreRecommendViewCell.h"

@implementation TCStoreRecommendViewCell

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
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.textColor = TCRGBColor(154, 154, 154);
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    
    YYTextView *textView = [[YYTextView alloc] init];
    textView.textColor = TCRGBColor(42, 42, 42);
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholderTextColor = TCRGBColor(154, 154, 154);
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.returnKeyType = UIReturnKeyDone;
    textView.layer.cornerRadius = 2.5;
    textView.layer.borderColor = TCRGBColor(212, 212, 212).CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    [self.contentView addSubview:textView];
    self.textView = textView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 18));
        make.centerY.equalTo(weakSelf.contentView.mas_top).with.offset(22.5);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.bottom.equalTo(weakSelf.titleLabel.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(93);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(45);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(99);
    }];
}

@end
