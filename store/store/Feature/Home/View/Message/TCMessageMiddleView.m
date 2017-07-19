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
        self.mainTitleLabel.text = homeMessage.body;
    }else if (self.style == TCMessageMiddleViewStyleMoneyView) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:homeMessage.avatar];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",homeMessage.repaymentAmount];
        self.moneyDesLabel.text = homeMessage.description;
        if (homeMessage.applicationTime) {
            self.moneySubTitleLabel.text = [NSString stringWithFormat:@"申请日期:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.applicationTime/1000]]];
        }
    }else if (self.style == TCMessageMiddleViewStyleSubTitleMiddleView) {
        self.mainTitleLabel.text = homeMessage.body;
        self.leftSubTitleLabel.text = homeMessage.description;
        self.secondSubTitleLabel.text = [NSString stringWithFormat:@"缴费周期：第%ld期",(long)homeMessage.periodicity];
        NSString *moneyTitle = @"缴费金额";
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillGeneration || homeMessage.messageBody.homeMessageType.type == TCMessageTypeRentBillPayment) {
            moneyTitle = @"房租金额";
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillPayment || homeMessage.messageBody.homeMessageType.type == TCMessageTypeCompaniesRentBillGeneration) {
            moneyTitle = @"企业租金";
        }
        if (homeMessage.repaymentTime) {
            self.thirdSubTitleLabel.text = [NSString stringWithFormat:@"缴费日期:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.repaymentTime/1000]]];
            self.fourSubTitleLabel.text = [NSString stringWithFormat:@"%@%.2f",moneyTitle,homeMessage.repaymentAmount];
        }else {
            self.thirdSubTitleLabel.text = [NSString stringWithFormat:@"%@%.2f",moneyTitle,homeMessage.repaymentAmount];
        }
    }else if (self.style == TCMessageMiddleViewStyleExtendCreditMiddleView) {
        self.mainTitleLabel.text = homeMessage.body;
        if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditEnable) {
            self.leftSubTitleLabel.text = homeMessage.description;
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditBillGeneration) {
            self.leftSubTitleLabel.text = [NSString stringWithFormat:@"还款日:%@",[self.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:homeMessage.repaymentTime/1000]]];
            self.rightSubTitleLabel.text = [NSString stringWithFormat:@"应还金额:%.2f",homeMessage.repaymentAmount];
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditBillPayment) {
            self.leftSubTitleLabel.text = [NSString stringWithFormat:@"应还金额:%.2f",homeMessage.repaymentAmount];
        }else if (homeMessage.messageBody.homeMessageType.type == TCMessageTypeCreditDisable) {
            self.leftSubTitleLabel.text = homeMessage.description;
            self.secondSubTitleLabel.text = [NSString stringWithFormat:@"欠款金额:%.2f",homeMessage.repaymentAmount];
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
