//
//  TCImageURLSynthesizer.h
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTCImageSourceOSS;

@interface TCImageURLSynthesizer : NSObject

/**
 合成图片资源的URL

 @param path 图片资源路径（由服务器返回）
 @return 图片资源的URL
 */
+ (NSURL *)synthesizeImageURLWithPath:(NSString *)path;

/**
 合成图片资源的路径（合成的路径要上传给服务器）

 @param name 图片名字，名字开头不能有“/”
 @param source 资源类型，如果是普通资源则传nil
 @return 图片资源的路径
 */
+ (NSString *)synthesizeImagePathWithName:(NSString *)name source:(NSString *)source;

@end
