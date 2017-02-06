//
//  TCBusinessHoursViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBusinessHoursViewCell.h"

@interface TCBusinessHoursViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *lineView;

@end

@implementation TCBusinessHoursViewCell

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"营业时间";
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *openTimeLabel = [[UILabel alloc] init];
    openTimeLabel.textColor = TCRGBColor(42, 42, 42);
    openTimeLabel.textAlignment = NSTextAlignmentCenter;
    openTimeLabel.font = [UIFont systemFontOfSize:16];
    openTimeLabel.userInteractionEnabled = YES;
    openTimeLabel.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    openTimeLabel.layer.borderWidth = 1;
    openTimeLabel.layer.cornerRadius = 2.5;
    openTimeLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:openTimeLabel];
    UITapGestureRecognizer *openTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTapOpenTimeLabelGesture:)];
    [openTimeLabel addGestureRecognizer:openTimeTap];
    
    UILabel *closeTimeLabel = [[UILabel alloc] init];
    closeTimeLabel.textColor = TCRGBColor(42, 42, 42);
    closeTimeLabel.textAlignment = NSTextAlignmentCenter;
    closeTimeLabel.font = [UIFont systemFontOfSize:16];
    closeTimeLabel.userInteractionEnabled = YES;
    closeTimeLabel.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    closeTimeLabel.layer.borderWidth = 1;
    closeTimeLabel.layer.cornerRadius = 2.5;
    closeTimeLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:closeTimeLabel];
    UITapGestureRecognizer *closeTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTapCloseTimeLabelGesture:)];
    [closeTimeLabel addGestureRecognizer:closeTimeTap];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    self.titleLabel = titleLabel;
    self.openTimeLabel = openTimeLabel;
    self.closeTimeLabel = closeTimeLabel;
    self.lineView = lineView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.height.mas_equalTo(21);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.openTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(90), 28));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(100);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.closeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(90), 28));
        make.left.equalTo(weakSelf.openTimeLabel.mas_right).with.offset(TCRealValue(31));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.openTimeLabel.mas_right).with.offset(TCRealValue(12));
        make.right.equalTo(weakSelf.closeTimeLabel.mas_left).with.offset(TCRealValue(-12));
    }];
}

- (void)handleTapOpenTimeLabelGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapOpenTimeLabelInBusinessHoursViewCell:)]) {
        [self.delegate didTapOpenTimeLabelInBusinessHoursViewCell:self];
    }
}

- (void)handleTapCloseTimeLabelGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapCloseTimeLabelInBusinessHoursViewCell:)]) {
        [self.delegate didTapCloseTimeLabelInBusinessHoursViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
