//
//  TCBankCardViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankCardViewCell.h"
#import "TCBankCard.h"

@interface TCBankCardViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CardNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation TCBankCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBankCard:(TCBankCard *)bankCard {
    _bankCard = bankCard;
    
    self.bgImageView.image = [UIImage imageNamed:bankCard.bgImage];
    self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
    self.bankNameLabel.text = bankCard.bankName;
    NSInteger index = bankCard.bankCardNum.length;
    if (index > 4) {
        index = index - 4;
    }
    NSString *lastNum = [bankCard.bankCardNum substringFromIndex:index];
    self.CardNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@", lastNum];
    self.deleteButton.hidden = !bankCard.showDelete;
}

- (IBAction)handleClickDeleteButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bankCardViewCell:didClickDeleteButtonWithBankCard:)]) {
        [self.delegate bankCardViewCell:self didClickDeleteButtonWithBankCard:self.bankCard];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
