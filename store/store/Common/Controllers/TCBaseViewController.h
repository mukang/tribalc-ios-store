//
//  TCBaseViewController.h
//  individual
//
//  Created by 王帅锋 on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCBaseViewController : UIViewController

@property (nonatomic) BOOL hideOriginalNavBar;

- (void)handleClickBackButton:(UIBarButtonItem *)sender;

@end
