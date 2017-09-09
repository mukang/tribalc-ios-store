//
//  TCCommonInputViewCell.h
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCCommonInputViewCell;

@protocol TCCommonInputViewCellDelegate <NSObject>

@optional
- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField;
- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField;
- (void)didTapContainerViewInCommonInputViewCell:(TCCommonInputViewCell *)cell;

@end

@interface TCCommonInputViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *placeholder;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic, getter=isInputEnabled) BOOL inputEnabled;
@property (nonatomic) BOOL hideSeparatorView; // default is YES.
@property (weak, nonatomic) id<TCCommonInputViewCellDelegate> delegate;

@end
