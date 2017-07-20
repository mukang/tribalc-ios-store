//
//  TCHomeMessageCell.h
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCHomeMessage;

@protocol TCHomeMessageCellDelegate <NSObject>

- (void)didClickMoreActionBtnWithMessageCell:(UITableViewCell *)cell;

@end

@interface TCHomeMessageCell : UITableViewCell

@property (strong, nonatomic) TCHomeMessage *homeMessage;

@property (weak, nonatomic) id <TCHomeMessageCellDelegate>delegate;

@end
