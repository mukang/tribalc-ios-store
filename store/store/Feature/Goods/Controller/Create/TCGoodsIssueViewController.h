//
//  TCGoodsIssueViewController.h
//  store
//
//  Created by 王帅锋 on 17/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"
#import "TCGoods.h"

@class  TCGoodsStandardMate;
@interface TCGoodsIssueViewController : TCBaseViewController

@property (strong, nonatomic) TCGoods *goods;

@property (strong, nonatomic) TCGoodsStandardMate *goodsStandardMate;

@end
