//
//  TCBankCardViewCell.h
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCBankCard;
@class TCBankCardViewCell;

@protocol TCBankCardViewCellDelegate <NSObject>

@optional
- (void)bankCardViewCell:(TCBankCardViewCell *)cell didClickDeleteButtonWithBankCard:(TCBankCard *)bankCard;

@end

@interface TCBankCardViewCell : UITableViewCell

@property (strong, nonatomic) TCBankCard *bankCard;
@property (weak, nonatomic) id<TCBankCardViewCellDelegate> delegate;

@end
