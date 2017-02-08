//
//  TCCommonSwitchViewCell.h
//  store
//
//  Created by 穆康 on 2017/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCCommonSwitchViewCellDelegate;

@interface TCCommonSwitchViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UISwitch *switchControl;
@property (weak, nonatomic) id<TCCommonSwitchViewCellDelegate> delegate;

@end

@protocol TCCommonSwitchViewCellDelegate <NSObject>

@optional
- (void)commonSwitchViewCell:(TCCommonSwitchViewCell *)cell didChangeSwitchControlWithOn:(BOOL)isOn;

@end
