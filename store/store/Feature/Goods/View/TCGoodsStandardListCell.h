//
//  TCGoodsStandardListCell.h
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCGoodsStandardMate;
@class TCGoodStandards;

@protocol TCGoodsStandardListCellDelegate <NSObject>

- (void)didClick:(UITableViewCell *)cell selected:(BOOL)selected;

@end


@interface TCGoodsStandardListCell : UITableViewCell
@property (strong, nonatomic) TCGoodsStandardMate *goodsStandardMate;

@property (weak, nonatomic) id<TCGoodsStandardListCellDelegate> delegate;

@property (strong, nonatomic) TCGoodStandards *goodsStandard;

@property (assign, nonatomic) BOOL select;
@end
