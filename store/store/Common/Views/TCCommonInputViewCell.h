//
//  TCCommonInputViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCCommonInputViewCellDelegate;

@interface TCCommonInputViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UITextField *textField;
@property (copy, nonatomic) NSString *placeholder;
@property (weak, nonatomic) id<TCCommonInputViewCellDelegate> delegate;

@end

@protocol TCCommonInputViewCellDelegate <NSObject>

@optional
- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField;
- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField;

@end
