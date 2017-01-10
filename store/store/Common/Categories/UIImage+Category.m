//
//  UIImage+Category.m
//  individual
//
//  Created by 穆康 on 2016/10/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "UIImage+Category.h"
#import <SDImageCache.h>

@implementation UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)shadowImageWithColor:(UIColor *)color {
    
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 0.5f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)placeholderImageWithNamed:(NSString *)name imageSize:(CGSize)size {
    
    NSString *key = [NSString stringWithFormat:@"%@%@", name, NSStringFromCGSize(size)];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    UIImage *image = [imageCache imageFromDiskCacheForKey:key];
    if (image) {
        return image;
    } else {         // 没有就创建再存储到缓存和磁盘
        UIImage *originalImage = [UIImage imageNamed:name];
        
        CGFloat targetLen = size.width <= size.height ? size.width : size.height;
        CGFloat originalImageLen = originalImage.size.width;
        if (originalImageLen > targetLen) {
            originalImageLen = targetLen;
        }
        CGFloat originalImageX = (size.width - originalImageLen) * 0.5f;
        CGFloat originalImageY = (size.height - originalImageLen) * 0.5f;
        CGRect originalImageF = CGRectMake(originalImageX, originalImageY, originalImageLen, originalImageLen);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, TCRGBColor(242, 242, 242).CGColor);
        CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
        [originalImage drawInRect:originalImageF];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 存储到缓存和磁盘
        [imageCache storeImage:image forKey:key];
        
        return image;
    }
}

+ (UIImage *)placeholderImageWithSize:(CGSize)size {
    return [self placeholderImageWithNamed:@"placeholder_image" imageSize:size];
}

@end
