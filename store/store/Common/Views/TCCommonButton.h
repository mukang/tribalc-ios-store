//
//  TCCommonButton.h
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCCommonButton : UIButton

/**
 生成一个带有默认size、默认点击样式的通用按钮

 @param title 标题
 @param target 方法的目标
 @param action 方法
 @return 通用样式按钮
 */
+ (instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
