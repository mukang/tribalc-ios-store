//
//  TCHomeMessageSubTitleCell.m
//  individual
//
//  Created by 王帅锋 on 2017/8/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageSubTitleCell.h"
#import "TCHomeMessage.h"

@interface TCHomeMessageSubTitleCell ()

@property (strong, nonatomic) UILabel *mainTitleLabel;

@property (strong, nonatomic) UILabel *leftSubTitleLabel;

@property (strong, nonatomic) UILabel *secondSubTitleLabel;

@property (strong, nonatomic) UILabel *thirdSubTitleLabel;

@property (strong, nonatomic) UILabel *fourSubTitleLabel;

@end

@implementation TCHomeMessageSubTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    [super setHomeMessage:homeMessage];
    
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

}

- (void)setUpSubViews {
    
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@143);
    }];
    
    [self.middleView addSubview:self.mainTitleLabel];
    [self.middleView addSubview:self.leftSubTitleLabel];
    [self.middleView addSubview:self.secondSubTitleLabel];
    [self.middleView addSubview:self.thirdSubTitleLabel];
    [self.middleView addSubview:self.fourSubTitleLabel];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(TCRealValue(35));
        make.right.equalTo(self.middleView).offset(-20);
        make.top.equalTo(self.middleView).offset(20);
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


@end
