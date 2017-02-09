//
//  TCGoodsListCell.h
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@class TCGoodsMeta;
@interface TCGoodsListCell : MGSwipeTableCell

@property (strong, nonatomic) TCGoodsMeta *good;

@end
