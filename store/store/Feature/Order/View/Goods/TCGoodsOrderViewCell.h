//
//  TCGoodsOrderViewCell.h
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCGoodsOrderItem;

@interface TCGoodsOrderViewCell : UICollectionViewCell

@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *purchaser;
@property (strong, nonatomic) TCGoodsOrderItem *orderItem;

@end
