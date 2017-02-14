//
//  TCWalletBillViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillViewCell.h"
#import "TCWalletBill.h"

@interface TCWalletBillViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TCWalletBillViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWalletBill:(TCWalletBill *)walletBill {
    _walletBill = walletBill;
    
    self.weekdayLabel.text = walletBill.weekday;
    self.detailTimeLabel.text = walletBill.detailTime;
    self.amountLabel.text = [NSString stringWithFormat:@"%0.2f", walletBill.amount];
    self.titleLabel.text = walletBill.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
