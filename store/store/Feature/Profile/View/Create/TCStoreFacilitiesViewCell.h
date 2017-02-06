//
//  TCStoreFacilitiesViewCell.h
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCStoreFacilitiesViewCellDelegate;

@interface TCStoreFacilitiesViewCell : UITableViewCell

@property (copy, nonatomic) NSArray *features;
@property (weak, nonatomic) id<TCStoreFacilitiesViewCellDelegate> delegate;

@end

@protocol TCStoreFacilitiesViewCellDelegate <NSObject>

@optional
- (void)storeFacilitiesViewCell:(TCStoreFacilitiesViewCell *)cell didSelectItemAtIndex:(NSInteger)index;

@end
