//
//  TCImageURLSynthesizer.m
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCImageURLSynthesizer.h"
#import "TCClientConfig.h"

static NSString *const TCPathSeparator = @"://";
NSString *const kTCImageSourceOSS = @"oss";

@implementation TCImageURLSynthesizer

+ (NSURL *)synthesizeImageURLWithPath:(NSString *)path {
    if (!path) return nil;
    
    NSArray *pathParts = [path componentsSeparatedByString:TCPathSeparator];
    NSString *firstPart = [pathParts firstObject];
    NSString *lastPart = [pathParts lastObject];
    
    NSString *imageURLString = nil;
    if ([firstPart.lowercaseString isEqualToString:kTCImageSourceOSS]) {
        imageURLString = [TCCLIENT_OSS_RESOURCES_BASE_URL stringByAppendingPathComponent:lastPart];
    } else {
        imageURLString = [NSString stringWithFormat:@"" TCCLIENT_RESOURCES_BASE_URL "%@", firstPart];
    }
    return [NSURL URLWithString:imageURLString];
}

+ (NSString *)synthesizeImagePathWithName:(NSString *)name source:(NSString *)source {
    if (!name) return nil;
    NSAssert(![name hasPrefix:@"/"], @"name（%@）不能以“/”开头", name);
    
    NSString *imagePath = nil;
    if ([source isEqualToString:kTCImageSourceOSS]) {
        imagePath = [NSString stringWithFormat:@"%@%@%@", kTCImageSourceOSS, TCPathSeparator, name];
    } else {
        imagePath = [NSString stringWithFormat:@"/%@", name];
    }
    return imagePath;
}

@end
