//
//  TCHomeMessageExtendCreditMiddleCell.m
//  individual
//
//  Created by 王帅锋 on 2017/8/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageExtendCreditMiddleCell.h"
#import "TCHomeMessage.h"

@interface TCHomeMessageExtendCreditMiddleCell ()

@property (strong, nonatomic) UILabel *mainTitleLabel;

@property (strong, nonatomic) UILabel *leftSubTitleLabel;

@property (strong, nonatomic) UILabel *rightSubTitleLabel;

@property (strong, nonatomic) UILabel *secondSubTitleLabel;

@end

@implementation TCHomeMessageExtendCreditMiddleCell

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

- (void)setUpSubViews {
    
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@102);
    }];
    
    [self.middleView addSubview:self.mainTitleLabel];
    [self.middleView addSubview:self.leftSubTitleLabel];
    [self.middleView addSubview:self.rightSubTitleLabel];
    [self.middleView addSubview:self.secondSubTitleLabel];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(TCRealValue(35));
        make.top.equalTo(self.middleView).offset(20);
        make.right.equalTo(self.middleView).offset(-20);
        make.height.equalTo(@20);
    }];
    [self.leftSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitleLabel);
        make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.middleView).offset(-30);
        make.height.equalTo(@20);
    }];
    
    [self.rightSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.middleView).offset(-TCRealValue(35));
        make.top.height.equalTo(self.leftSubTitleLabel);
    }];
    
    [self.secondSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.equalTo(self.leftSubTitleLabel);
        make.top.equalTo(self.leftSubTitleLabel.mas_bottom).offset(5);
        
    }];

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



@end
