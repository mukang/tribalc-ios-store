//
//  UIImage+Category.h
//  individual
//
//  Created by 穆康 on 2016/10/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  根据颜色生成一张尺寸为1*1的相同颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色生成一张尺寸为1*0.5的相同颜色图片(用于阴影线)
 */
+ (UIImage *)shadowImageWithColor:(UIColor *)color;

/**
 生成一张占位图

 @param name 图片名字
 @param size 期望生成的占位图尺寸
 @return 占位图
 */
+ (UIImage *)placeholderImageWithNamed:(NSString *)name imageSize:(CGSize)size;

/**
 生成一张默认占位图

 @param size 期望生成的占位图尺寸
 @return 占位图
 */
+ (UIImage *)placeholderImageWithSize:(CGSize)size;

@end
