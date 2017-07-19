//
//  TCWalletBillViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>

@interface TCWalletBillViewController : TCBaseViewController

@property (copy, nonatomic) NSString *tradingType;

@property (copy, nonatomic) NSString *face2face;

@property (assign, nonatomic) BOOL isWithDraw;

@property (copy, nonatomic) NSString *accountType;

@end
