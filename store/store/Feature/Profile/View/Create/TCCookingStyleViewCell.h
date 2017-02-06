//
//  TCCookingStyleViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCCookingStyleViewCellDelegate;

@interface TCCookingStyleViewCell : UITableViewCell

@property (copy, nonatomic) NSArray *features;
@property (weak, nonatomic) id<TCCookingStyleViewCellDelegate> delegate;

@end

@protocol TCCookingStyleViewCellDelegate <NSObject>

@optional
- (void)cookingStyleViewCell:(TCCookingStyleViewCell *)cell didSelectItemAtIndex:(NSInteger)index;

@end
