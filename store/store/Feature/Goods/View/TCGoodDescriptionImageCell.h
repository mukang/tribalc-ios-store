//
//  TCGoodDescriptionImageCell.h
//  store
//
//  Created by 王帅锋 on 17/4/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCGoodDescriptionImageCellDelegate <NSObject>

- (void)didClickDeleteBtn:(UITableViewCell *)cell;

@end

@interface TCGoodDescriptionImageCell : UITableViewCell

@property (copy, nonatomic) NSString *urlStr;

@property (weak, nonatomic) id<TCGoodDescriptionImageCellDelegate> delegate;

@end
