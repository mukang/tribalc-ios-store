//
//  TCImageCompressHandler.h
//  individual
//
//  Created by 穆康 on 2017/3/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 图像压缩处理器
 */
@interface TCImageCompressHandler : NSObject

/**
 压缩图像
 
 @param image 需要压缩的图像
 @param maxLength 指定大小
 @return 压缩后的图像数据
 */
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
