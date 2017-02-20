//
//  TCCreateGoodsStandardController.h
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"
#import "TCGoodsStandardMate.h"

typedef void(^MyBlock)(TCGoodsStandardMate *,NSString *);


@interface TCCreateGoodsStandardController : TCBaseViewController

- (instancetype)initWithGoodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate;


@property (copy, nonatomic) MyBlock myBlock;

@end
