//
//  TCStoreSurroundingViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCStoreSurroundingViewCellDelegate;

@interface TCStoreSurroundingViewCell : UICollectionViewCell

@property (copy, nonatomic) NSString *picture;
@property (weak, nonatomic) id<TCStoreSurroundingViewCellDelegate> delegate;

@end

@protocol TCStoreSurroundingViewCellDelegate <NSObject>

@optional
- (void)didClickDeleteButtonInStoreSurroundingViewCell:(TCStoreSurroundingViewCell *)cell;

@end
