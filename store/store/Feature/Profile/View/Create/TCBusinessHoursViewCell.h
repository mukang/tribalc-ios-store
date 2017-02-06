//
//  TCBusinessHoursViewCell.h
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCBusinessHoursViewCellDelegate;

@interface TCBusinessHoursViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *openTimeLabel;
@property (weak, nonatomic) UILabel *closeTimeLabel;
@property (weak, nonatomic) id<TCBusinessHoursViewCellDelegate> delegate;

@end

@protocol TCBusinessHoursViewCellDelegate <NSObject>

@optional
- (void)didTapOpenTimeLabelInBusinessHoursViewCell:(TCBusinessHoursViewCell *)cell;
- (void)didTapCloseTimeLabelInBusinessHoursViewCell:(TCBusinessHoursViewCell *)cell;

@end
