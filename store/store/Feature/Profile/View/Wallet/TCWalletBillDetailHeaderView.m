//
//  TCWalletBillDetailHeaderView.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillDetailHeaderView.h"

@implementation TCWalletBillDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconBgView.layer.cornerRadius = 35;
    self.iconBgView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 31.75;
    self.iconImageView.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
