//
//  TCGoodDescriptionViewController.h
//  store
//
//  Created by 王帅锋 on 17/4/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef void (^TCGoodDescriptionDoneBlock)(NSArray *);

@interface TCGoodDescriptionViewController : TCBaseViewController

@property (copy, nonatomic) NSArray *urlArr;

@property (copy, nonatomic) TCGoodDescriptionDoneBlock doneBlock;

@end
