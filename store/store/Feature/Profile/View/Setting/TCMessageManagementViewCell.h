//
//  TCMessageManagementViewCell.h
//  individual
//
//  Created by 穆康 on 2017/8/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCMessageManagement;

@protocol TCMessageManagementViewCellDelegate;
@interface TCMessageManagementViewCell : UITableViewCell

@property (strong, nonatomic) TCMessageManagement *messageManagement;
@property (weak, nonatomic) id<TCMessageManagementViewCellDelegate> delegate;

@end


@protocol TCMessageManagementViewCellDelegate <NSObject>

@optional
- (void)messageManagementViewCell:(TCMessageManagementViewCell *)cell didClickSwitchButtonWithType:(NSString *)messageType open:(BOOL)open;

@end


