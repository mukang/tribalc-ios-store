//
//  TCCreateStandardCell.h
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCCreateStandardCellDelegate <NSObject>

@optional
- (void)addSecondaryStandardCell;
- (void)deleteCurrentCell:(UITableViewCell *)cell;
- (void)textFieldShouldBeginEditting:(UITableViewCell *)cell;
- (void)textFieldShouldEndEditting:(UITableViewCell *)cell;
- (void)createOrReloadPriceAndRepertoryCell:(UITableViewCell *)cell;
- (void)textFieldShouldReturnn;
@end

@interface TCCreateStandardCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *standardNameTextField;

@property (strong, nonatomic) UITextField *standardContentTextField;

@property (weak, nonatomic) id<TCCreateStandardCellDelegate> delegate;

@property (copy, nonatomic) NSArray *currentStandards;

@property (assign, nonatomic) BOOL isNeedAdd;

- (CGFloat)cellHeight;

- (void)hideAddBtn;

- (void)showAddBtn;

@end
