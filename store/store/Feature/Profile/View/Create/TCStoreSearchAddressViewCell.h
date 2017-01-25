//
//  TCStoreSearchAddressViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCStoreSearchAddressViewCellDelegate;

@interface TCStoreSearchAddressViewCell : UITableViewCell

@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) id<TCStoreSearchAddressViewCellDelegate> delegate;

@end

@protocol TCStoreSearchAddressViewCellDelegate <NSObject>

@optional
- (void)storeSearchAddressViewCell:(TCStoreSearchAddressViewCell *)cell didClickSearchButtonWithAddress:(NSString *)address;

@end
