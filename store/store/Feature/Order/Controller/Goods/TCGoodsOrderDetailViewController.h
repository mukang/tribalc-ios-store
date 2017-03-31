//
//  TCGoodsOrderDetailViewController.h
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCGoodsOrder;

typedef void(^TCOrderStatusChangeBlock)(TCGoodsOrder *goodsOrder);

@interface TCGoodsOrderDetailViewController : TCBaseViewController

@property (strong, nonatomic) TCGoodsOrder *goodsOrder;
@property (copy, nonatomic) TCOrderStatusChangeBlock statusChangeBlock;

@end
