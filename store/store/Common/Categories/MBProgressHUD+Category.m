//
//  MBProgressHUD+Category.m
//  individual
//
//  Created by 穆康 on 2016/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "MBProgressHUD+Category.h"

@implementation MBProgressHUD (Category)

+ (void)showHUDWithMessage:(NSString *)message {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:keyWindow];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:2.0];
}

+ (void)showHUD:(BOOL)animated {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:keyWindow animated:animated];
}

+ (void)hideHUD:(BOOL)animated {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:keyWindow animated:animated];
}

+ (void)showHUDWithMessage:(NSString *)message afterDelay:(CGFloat)delay{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:keyWindow];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:delay];
}

@end
