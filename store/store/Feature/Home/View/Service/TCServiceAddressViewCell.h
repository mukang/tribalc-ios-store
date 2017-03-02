//
//  TCServiceAddressViewCell.h
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCServiceAddressViewCellDelegate;
@interface TCServiceAddressViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *phoneLabel;
@property (weak, nonatomic) UILabel *addressLabel;
@property (weak, nonatomic) id<TCServiceAddressViewCellDelegate> delegate;

@end

@protocol TCServiceAddressViewCellDelegate <NSObject>

@optional
- (void)didClickPhoneButtonInServiceAddressViewCell:(TCServiceAddressViewCell *)cell;
- (void)didClickAddressButtonInServiceAddressViewCell:(TCServiceAddressViewCell *)cell;

@end
