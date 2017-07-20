//
//  TCHomeMessageCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageCell.h"
#import "TCHomeMessage.h"
#import "TCMessageMiddleView.h"

#define kScale (TCScreenWidth > 375 ? 3 : 2)

@interface TCHomeMessageCell ()

@property (strong, nonatomic) UIView *topBgView;

@property (strong, nonatomic) UIView *lineView1;

@property (strong, nonatomic) UIImageView *titleIcon;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIButton *moreActionBtn;

@property (strong, nonatomic) UIView *lineView2;

@property (strong, nonatomic) UIView *middleView;

@property (strong, nonatomic) UIView *lineView3;

@property (strong, nonatomic) UIButton *checkBtn;

@property (strong, nonatomic) UIView *lineView4;

@property (strong, nonatomic) TCMessageMiddleView *moneyMiddleView;

@property (strong, nonatomic) TCMessageMiddleView *extendCreditMiddleView;

@property (strong, nonatomic) TCMessageMiddleView *subTitleMiddleView;

@property (strong, nonatomic) TCMessageMiddleView *onlyMainTitleMiddleView;

@property (weak, nonatomic) UIView *currentView;

@end

@implementation TCHomeMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    if (_homeMessage != homeMessage) {
        _homeMessage = homeMessage;
        
        self.titleLabel.text = homeMessage.messageBody.homeMessageType.homeMessageTypeCategory;
        
        NSString *dateStr;
        NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:homeMessage.createDate/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSString *str1 = [formatter stringFromDate:[NSDate date]];
        NSString *str2 = [formatter stringFromDate:createDate];
        if ([str1 isEqualToString:str2]) {
            [formatter setDateFormat:@"HH:mm"];
            dateStr = [formatter stringFromDate:createDate];
        }else {
            [formatter setDateFormat:@"MM-dd HH:mm"];
            dateStr = [formatter stringFromDate:createDate];
        }
        
        self.timeLabel.text = dateStr;
        
        TCMessageType type = homeMessage.messageBody.homeMessageType.type;
        if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge) {
            self.titleIcon.image = [UIImage imageNamed:@"walletAssistantIcon"];
        }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment) {
            self.titleIcon.image = [UIImage imageNamed:@"creditAssistantIcon"];
        }else if (type == TCMessageTypeRentCheckIn || type == TCMessageTypeRentBillGeneration || type == TCMessageTypeRentBillPayment) {
            self.titleIcon.image = [UIImage imageNamed:@"apartmentAssistantIcon"];
        }else if (type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw) {
            self.titleIcon.image = [UIImage imageNamed:@"storeAssistantIcon"];
        }else if (type == TCMessageTypeCompaniesAdmin || type == TCMessageTypeCompaniesRentBillGeneration || type == TCMessageTypeCompaniesRentBillPayment) {
            self.titleIcon.image = [UIImage imageNamed:@"bussinessAssistantIcon"];
        }
        
        if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw) {
            [self.currentView removeFromSuperview];
            [self.middleView addSubview:self.moneyMiddleView];
            self.moneyMiddleView.homeMessage = homeMessage;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@102);
            }];
            self.currentView = self.moneyMiddleView;
        }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment) {
            [self.currentView removeFromSuperview];
            [self.middleView addSubview:self.extendCreditMiddleView];
            self.extendCreditMiddleView.homeMessage = homeMessage;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@102);
            }];
            self.currentView = self.extendCreditMiddleView;
        }else if (type == TCMessageTypeRentCheckIn) {
            [self.currentView removeFromSuperview];
            [self.middleView addSubview:self.onlyMainTitleMiddleView];
            self.onlyMainTitleMiddleView.homeMessage = homeMessage;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@62);
            }];
            self.currentView = self.onlyMainTitleMiddleView;
        }else {
            [self.currentView removeFromSuperview];
            [self.middleView addSubview:self.subTitleMiddleView];
            self.subTitleMiddleView.homeMessage = homeMessage;
            [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@143);
            }];
            self.currentView = self.subTitleMiddleView;
        }
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

- (void)btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreActionBtnWithMessageCell:)]) {
        [self.delegate didClickMoreActionBtnWithMessageCell:self];
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.topBgView];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.titleIcon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moreActionBtn];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.middleView];
    [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.checkBtn];
    [self.contentView addSubview:self.lineView4];
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(@8);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.topBgView.mas_bottom);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1).offset(7);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@26);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleIcon.mas_right).offset(10);
        make.top.equalTo(self.titleIcon);
        make.height.equalTo(@16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.height.equalTo(@10);
    }];
    
    [self.moreActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.lineView1.mas_bottom);
        make.width.height.equalTo(@40);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lineView1.mas_bottom).offset(40);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lineView2.mas_bottom);
        make.height.equalTo(@102);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.middleView.mas_bottom);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.lineView3.mas_bottom);
        make.height.equalTo(@32);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.checkBtn.mas_bottom);
        make.height.equalTo(@(1/kScale));
        make.bottom.equalTo(self.contentView);
    }];
    

}

- (TCMessageMiddleView *)extendCreditMiddleView {
    if (_extendCreditMiddleView == nil) {
        _extendCreditMiddleView = [[TCMessageMiddleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 102) style:TCMessageMiddleViewStyleExtendCreditMiddleView];
    }
    return _extendCreditMiddleView;
}

- (TCMessageMiddleView *)onlyMainTitleMiddleView {
    if (_onlyMainTitleMiddleView == nil) {
        _onlyMainTitleMiddleView = [[TCMessageMiddleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 62) style:TCMessageMiddleViewStyleOnlyMainTitle];
    }
    return _onlyMainTitleMiddleView;
}

- (TCMessageMiddleView *)subTitleMiddleView {
    if (_subTitleMiddleView == nil) {
        _subTitleMiddleView = [[TCMessageMiddleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 143) style:TCMessageMiddleViewStyleSubTitleMiddleView];
    }
    return _subTitleMiddleView;
}

- (TCMessageMiddleView *)moneyMiddleView {
    if (_moneyMiddleView == nil) {
        _moneyMiddleView = [[TCMessageMiddleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 102) style:TCMessageMiddleViewStyleMoneyView];
    }
    return _moneyMiddleView;
}

- (UIView *)lineView4 {
    if (_lineView4 == nil) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView4;
}

- (UIButton *)checkBtn {
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"立即查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:TCGrayColor forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _checkBtn;
}

- (UIView *)lineView3 {
    if (_lineView3 == nil) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView3;
}

- (UIView *)middleView {
    if (_middleView == nil) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = TCRGBColor(250, 252, 252);
    }
    return _middleView;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView2;
}

- (UIButton *)moreActionBtn {
    if (_moreActionBtn == nil) {
        _moreActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreActionBtn setTitle:@"···" forState:UIControlStateNormal];
        [_moreActionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [_moreActionBtn setTitleColor:TCGrayColor forState:UIControlStateNormal];
        [_moreActionBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreActionBtn;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TCGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"15:10";
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"钱包助手";
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIImageView *)titleIcon {
    if (_titleIcon == nil) {
        _titleIcon = [[UIImageView alloc] init];
    }
    return _titleIcon;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView1;
}

- (UIView *)topBgView {
    if (_topBgView == nil) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = TCRGBColor(239, 244, 245);
    }
    return _topBgView;
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
