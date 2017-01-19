//
//  TCStoreCategoryViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCStoreCategoryInfo;
@protocol TCStoreCategoryViewCellDelegate;

@interface TCStoreCategoryViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *titleImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) NSArray *categoryInfoArray;
@property (weak, nonatomic) id<TCStoreCategoryViewCellDelegate> delegate;

@end

@protocol TCStoreCategoryViewCellDelegate <NSObject>

@optional
- (void)storeCategoryViewCell:(TCStoreCategoryViewCell *)cell didSelectItemWithCategoryInfo:(TCStoreCategoryInfo *)categoryInfo;

@end
