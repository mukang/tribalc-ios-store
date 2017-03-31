//
//  TCCreateGoodsViewController.h
//  store
//
//  Created by 王帅锋 on 17/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCGoodsMeta.h"
#import "TCGoodsStandardMate.h"

@class TCGoodsStandardMate;
@interface TCCreateGoodsViewController : TCBaseViewController

@property (strong, nonatomic) TCGoodsMeta *goods;

@property (strong, nonatomic) TCGoodsStandardMate *currentGoodsStandardMate;

@end
