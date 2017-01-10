//
//  MBProgressHUD+Category.h
//  individual
//
//  Created by 穆康 on 2016/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Category)

/**
 展示提示信息，2秒后会自动消失

 @param message 需要展示的信息
 */
+ (void)showHUDWithMessage:(NSString *)message;

/**
 展示带UIActivityIndicatorView的HUD

 @param animated 是否有动画
 */
+ (void)showHUD:(BOOL)animated;

/**
 隐藏带UIActivityIndicatorView的HUD

 @param animated 是否有动画
 */
+ (void)hideHUD:(BOOL)animated;
/**
 展示提示信息
 
 @param message 需要展示的信息
 @param delay 停留时间
 */
+ (void)showHUDWithMessage:(NSString *)message afterDelay:(CGFloat)delay;

@end
