//
//  TCLaunchViewController.h
//  individual
//
//  Created by 穆康 on 2017/1/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TCLaunchWindowDidAppearNotification;
extern NSString *const TCLaunchWindowDidDisappearNotification;

@interface TCLaunchViewController : UIViewController

@property (weak, nonatomic) UIWindow *launchWindow;

@end
