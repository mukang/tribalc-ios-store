//
//  TCWalletBillViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillViewCell.h"
#import "TCWalletBill.h"
#import "TCWithDrawRequest.h"
#import <UIImageView+WebCache.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>

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
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 21;
}

- (void)setWithdrawRequest:(TCWithDrawRequest *)withdrawRequest {
    _withdrawRequest = withdrawRequest;
    
    self.weekdayLabel.text = withdrawRequest.weekday;
    self.detailTimeLabel.text = withdrawRequest.detailTime;
    self.amountLabel.text = [NSString stringWithFormat:@"%0.2f", withdrawRequest.amount];
    NSString *statusStr;
    if ([withdrawRequest.status isEqualToString:@"CREATED"]) {
        statusStr = @"已创建";
    }else if ([withdrawRequest.status isEqualToString:@"COMMITTED"]) {
        statusStr = @"已提交";
    }else if ([withdrawRequest.status isEqualToString:@"PAYED"]) {
        statusStr = @"已支付";
    }else if ([withdrawRequest.status isEqualToString:@"FINISHED"]) {
        statusStr = @"已完成";
    }else if ([withdrawRequest.status isEqualToString:@"FAILURE"]) {
        statusStr = @"已失败";
    }else if ([withdrawRequest.status isEqualToString:@"REJECTED"]) {
        statusStr = @"已驳回";
    }
    self.titleLabel.text = statusStr;
    if ([withdrawRequest.ownerId isKindOfClass:[NSString class]]) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:withdrawRequest.ownerId needTimestamp:NO];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    }
}

- (void)setWalletBill:(TCWalletBill *)walletBill {
    _walletBill = walletBill;
    
    self.weekdayLabel.text = walletBill.weekday;
    self.detailTimeLabel.text = walletBill.detailTime;
    self.amountLabel.text = [NSString stringWithFormat:@"%0.2f", walletBill.amount];
    self.titleLabel.text = walletBill.title;
    
    if ([walletBill.anotherId isKindOfClass:[NSString class]]) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:walletBill.anotherId needTimestamp:NO];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
