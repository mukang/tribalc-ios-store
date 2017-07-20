//
//  TCMessageMiddleView.m
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMessageMiddleView.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>


@interface TCMessageMiddleView ()

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *moneyDesLabel;

@property (strong, nonatomic) UILabel *moneySubTitleLabel;

@property (strong, nonatomic) UILabel *mainTitleLabel;

@property (strong, nonatomic) UILabel *leftSubTitleLabel;

@property (strong, nonatomic) UILabel *rightSubTitleLabel;

@property (strong, nonatomic) UILabel *secondSubTitleLabel;

@property (strong, nonatomic) UILabel *thirdSubTitleLabel;

@property (strong, nonatomic) UILabel *fourSubTitleLabel;

@property (assign, nonatomic) TCMessageMiddleViewStyle style;

@property (strong, nonatomic) NSDateFormatter *dataFormatter;

@end

@implementation TCMessageMiddleView

- (instancetype)initWithFrame:(CGRect)frame style:(TCMessageMiddleViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self setUpViews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    _homeMessage = homeMessage;
    
    if (self.style == TCMessageMiddleViewStyleOnlyMainTitle) {
        self.rightSubTitleLabel.hidden = YES;
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentCheckIn) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:homeMessage.messageBody.body];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"hi"];
            attch.bounds = CGRectMake(5, -4, 17, 17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:string];
            self.mainTitleLabel.attributedText = att;
        }else {
            self.mainTitleLabel.text = homeMessage.messageBody.body;
        }
    }else if (self.style == TCMessageMiddleViewStyleMoneyView) {
        self.rightSubTitleLabel.hidden = YES;
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:homeMessage.messageBody.avatar];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",homeMessage.messageBody.repaymentAmount];
        self.moneyDesLabel.text = homeMessage.messageBody.desc;
        if (homeMessage.messageBody.applicationTime) {
            self.moneySubTitleLabel.text = [NSString stringWithFormat:@"申请日期:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.messageBody.applicationTime/1000]]];
        }else {
            self.moneySubTitleLabel.text = nil;
        }
    }else if (self.style == TCMessageMiddleViewStyleSubTitleMiddleView) {
        self.rightSubTitleLabel.hidden = YES;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:homeMessage.messageBody.body];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.bounds = CGRectMake(5, -4, 17, 17);
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillPayment || homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillPayment) {
            attch.image = [UIImage imageNamed:@"finished"];
            NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:str];
            self.mainTitleLabel.attributedText = att;
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillGeneration || homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillGeneration) {
            attch.image = [UIImage imageNamed:@"warning"];
            NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:str];
            self.mainTitleLabel.attributedText = att;
        }else {
            self.mainTitleLabel.text = homeMessage.messageBody.body;
        }
        self.leftSubTitleLabel.text = homeMessage.messageBody.desc;
        self.secondSubTitleLabel.text = [NSString stringWithFormat:@"缴费周期：第%ld期",(long)homeMessage.messageBody.periodicity];
        NSString *moneyTitle = @"缴费金额";
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillGeneration || homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillPayment) {
            moneyTitle = @"房租金额";
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillPayment || homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillGeneration) {
            moneyTitle = @"企业租金";
        }
        if (homeMessage.messageBody.repaymentTime) {
            self.thirdSubTitleLabel.text = [NSString stringWithFormat:@"缴费日期:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.messageBody.repaymentTime/1000]]];
            self.fourSubTitleLabel.text = [NSString stringWithFormat:@"%@%.2f",moneyTitle,homeMessage.messageBody.repaymentAmount];
        }else {
            self.thirdSubTitleLabel.text = [NSString stringWithFormat:@"%@%.2f",moneyTitle,homeMessage.messageBody.repaymentAmount];
            self.fourSubTitleLabel.text = nil;
        }
    }else if (self.style == TCMessageMiddleViewStyleExtendCreditMiddleView) {
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:homeMessage.messageBody.body];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.bounds = CGRectMake(5, -4, 17, 17);
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditBillPayment) {
            attch.image = [UIImage imageNamed:@"finished"];
            NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:str];
            self.mainTitleLabel.attributedText = att;
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditDisable) {
            attch.image = [UIImage imageNamed:@"disabled"];
            NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:str];
            self.mainTitleLabel.attributedText = att;
        }else {
            self.mainTitleLabel.text = homeMessage.messageBody.body;
        }
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditEnable) {
            self.leftSubTitleLabel.text = homeMessage.messageBody.desc;
            self.rightSubTitleLabel.hidden = YES;
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditBillGeneration) {
            self.leftSubTitleLabel.text = [NSString stringWithFormat:@"还款日:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.messageBody.repaymentTime/1000]]];
            self.rightSubTitleLabel.hidden = NO;
            self.rightSubTitleLabel.text = [NSString stringWithFormat:@"应还金额:%.2f",homeMessage.messageBody.repaymentAmount];
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditBillPayment) {
            self.rightSubTitleLabel.hidden = YES;
            self.leftSubTitleLabel.text = [NSString stringWithFormat:@"应还金额:%.2f",homeMessage.messageBody.repaymentAmount];
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditDisable) {
            self.leftSubTitleLabel.text = homeMessage.messageBody.desc;
            self.rightSubTitleLabel.hidden = YES;
            self.secondSubTitleLabel.text = [NSString stringWithFormat:@"欠款金额:%.2f",homeMessage.messageBody.repaymentAmount];
        }
    }
}

- (void)setUpViews {
    if (self.style == TCMessageMiddleViewStyleMoneyView) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.moneyDesLabel];
        [self addSubview:self.moneySubTitleLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.equalTo(@56);
            make.left.equalTo(self).offset(TCRealValue(60));
        }];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(TCRealValue(30));
            make.top.equalTo(self.iconImageView);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@33);
        }];
        
        [self.moneyDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moneyLabel);
            make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
            make.right.equalTo(self.moneyLabel);
        }];
        
        [self.moneySubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.moneyDesLabel);
            make.top.equalTo(self.moneyDesLabel.mas_bottom).offset(5);
        }];
        
    }else if (self.style == TCMessageMiddleViewStyleExtendCreditMiddleView) {
        [self addSubview:self.mainTitleLabel];
        [self addSubview:self.leftSubTitleLabel];
        [self addSubview:self.rightSubTitleLabel];
        [self addSubview:self.secondSubTitleLabel];
        
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(TCRealValue(35));
            make.top.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@20);
        }];
        [self.leftSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTitleLabel);
            make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(5);
            make.right.equalTo(self).offset(-30);
            make.height.equalTo(@20);
        }];
        
        [self.rightSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-TCRealValue(35));
            make.top.height.equalTo(self.leftSubTitleLabel);
        }];
        
        [self.secondSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.height.equalTo(self.leftSubTitleLabel);
            make.top.equalTo(self.leftSubTitleLabel.mas_bottom).offset(5);
            
        }];
    }else if (self.style == TCMessageMiddleViewStyleSubTitleMiddleView) {
        [self addSubview:self.mainTitleLabel];
        [self addSubview:self.leftSubTitleLabel];
        [self addSubview:self.secondSubTitleLabel];
        [self addSubview:self.thirdSubTitleLabel];
        [self addSubview:self.fourSubTitleLabel];
        
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(TCRealValue(35));
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(20);
            make.height.equalTo(@20);
        }];
        
        [self.leftSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.right.equalTo(self.mainTitleLabel);
            make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(5);
        }];
        
        [self.secondSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.leftSubTitleLabel);
            make.top.equalTo(self.leftSubTitleLabel.mas_bottom).offset(5);
        }];
        
        [self.thirdSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.secondSubTitleLabel);
            make.top.equalTo(self.secondSubTitleLabel.mas_bottom).offset(5);
        }];
        
        [self.fourSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.thirdSubTitleLabel);
            make.top.equalTo(self.thirdSubTitleLabel.mas_bottom).offset(5);
        }];
    }else if (self.style == TCMessageMiddleViewStyleOnlyMainTitle) {
        [self addSubview:self.mainTitleLabel];
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(TCRealValue(35));
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
            make.right.equalTo(self).offset(-20);
        }];
    }
}

- (NSDateFormatter *)dataFormatter {
    if (_dataFormatter == nil) {
        _dataFormatter = [[NSDateFormatter alloc] init];
        [_dataFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dataFormatter;
}

- (UILabel *)fourSubTitleLabel {
    if (_fourSubTitleLabel == nil) {
        _fourSubTitleLabel = [[UILabel alloc] init];
        _fourSubTitleLabel.textColor = TCBlackColor;
        _fourSubTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fourSubTitleLabel;
}

- (UILabel *)thirdSubTitleLabel {
    if (_thirdSubTitleLabel == nil) {
        _thirdSubTitleLabel = [[UILabel alloc] init];
        _thirdSubTitleLabel.textColor = TCBlackColor;
        _thirdSubTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _thirdSubTitleLabel;
}

- (UILabel *)secondSubTitleLabel {
    if (_secondSubTitleLabel == nil) {
        _secondSubTitleLabel = [[UILabel alloc] init];
        _secondSubTitleLabel.textColor = TCBlackColor;
        _secondSubTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _secondSubTitleLabel;
}

- (UILabel *)rightSubTitleLabel {
    if (_rightSubTitleLabel == nil) {
        _rightSubTitleLabel = [[UILabel alloc] init];
        _rightSubTitleLabel.textColor = TCBlackColor;
        _rightSubTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _rightSubTitleLabel;
}

- (UILabel *)leftSubTitleLabel {
    if (_leftSubTitleLabel == nil) {
        _leftSubTitleLabel = [[UILabel alloc] init];
        _leftSubTitleLabel.textColor = TCBlackColor;
        _leftSubTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _leftSubTitleLabel;
}

- (UILabel *)mainTitleLabel {
    if (_mainTitleLabel == nil) {
        _mainTitleLabel = [[UILabel alloc] init];
        _mainTitleLabel.textColor = [UIColor blackColor];
        _mainTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mainTitleLabel;
}

- (UILabel *)moneySubTitleLabel {
    if (_moneySubTitleLabel == nil) {
        _moneySubTitleLabel = [[UILabel alloc] init];
        _moneySubTitleLabel.textColor = TCGrayColor;
        _moneySubTitleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _moneySubTitleLabel;
}

- (UILabel *)moneyDesLabel {
    if (_moneyDesLabel == nil) {
        _moneyDesLabel = [[UILabel alloc] init];
        _moneyDesLabel.textColor = TCBlackColor;
        _moneyDesLabel.font = [UIFont systemFontOfSize:12];
    }
    return _moneyDesLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:32];
    }
    return _moneyLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 28;
    }
    return _iconImageView;
}



@end
