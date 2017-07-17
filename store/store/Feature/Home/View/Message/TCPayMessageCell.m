//
//  TCPayMessageCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPayMessageCell.h"

@interface TCPayMessageCell ()

@property (strong, nonatomic) UIView *grayView;

@property (strong, nonatomic) UIView *lineView1;

@property (strong, nonatomic) UILabel *messageTypeLabel;

@property (strong, nonatomic) UILabel *createTimeLabel;

@property (strong, nonatomic) UIButton *moreActionBtn;

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *messageDesLabel;

@property (strong, nonatomic) UIButton *checkBtn;

@property (strong, nonatomic) UIView *lineView2;

@end

@implementation TCPayMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setUpViews {
    
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UILabel alloc] init];
        _lineView2.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView2;
}

- (UIButton *)checkBtn {
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"立即查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:TCLightGrayColor forState:UIControlStateNormal];
    }
    return _checkBtn;
}

- (UILabel *)messageDesLabel {
    if (_messageDesLabel == nil) {
        _messageDesLabel = [[UILabel alloc] init];
        _messageDesLabel.textColor = TCGrayColor;
        _messageDesLabel.font = [UIFont systemFontOfSize:10];
    }
    return _messageDesLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = TCBlackColor;
    }
    return _moneyLabel;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.clipsToBounds = YES;
        _logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _logoImageView.layer.borderWidth = 2.0;
        _logoImageView.layer.cornerRadius = TCRealValue(55)/2;
    }
    return _logoImageView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UIButton *)moreActionBtn {
    if (_moreActionBtn == nil) {
        _moreActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _moreActionBtn;
}

- (UILabel *)createTimeLabel {
    if (_createTimeLabel == nil) {
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.textColor = TCLightGrayColor;
        _createTimeLabel.font = [UIFont systemFontOfSize:11];
    }
    return _createTimeLabel;
}

- (UILabel *)messageTypeLabel {
    if (_messageTypeLabel == nil) {
        _messageTypeLabel = [[UILabel alloc] init];
        _messageTypeLabel.textColor = TCGrayColor;
        _messageTypeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _messageTypeLabel;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView1;
}

- (UIView *)grayView {
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = TCRGBColor(237, 245, 245);
    }
    return _grayView;
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
