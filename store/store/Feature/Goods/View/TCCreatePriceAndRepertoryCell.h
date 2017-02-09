//
//  TCCreatePriceAndRepertoryCell.h
//  store
//
//  Created by 王帅锋 on 17/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCCreatePriceAndRepertoryCellDelegate <NSObject>

@optional
- (void)deleteCurrentStandard:(UITableViewCell *)cell;

- (void)textFieldDidEndEditting:(NSDictionary *)dict;

@end

@interface TCCreatePriceAndRepertoryCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *orignPriceTextField;

@property (strong, nonatomic) UITextField *salePriceTextField;

@property (strong, nonatomic) UITextField *repertoryTextField;

@property (strong, nonatomic) id<TCCreatePriceAndRepertoryCellDelegate> delegate;

- (CGFloat)cellHeight;
@end
