//
//  TCFunctions.m
//  individual
//
//  Created by 穆康 on 2016/10/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCFunctions.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#ifndef _TCFunctions_m
#define _TCFunctions_m

#pragma mark - NSString 操作

NSString * TCDigestMD5(NSString * text) {
    const char * textCPtr = [text UTF8String];
    if (textCPtr == NULL) {
        textCPtr = "";
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(textCPtr, (CC_LONG)strlen(textCPtr), digest);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];
}

NSString * TCDigestMD5ToData(NSData *data) {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];
}

#pragma mark - 设备操作

NSString * TCGetDeviceModel() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

NSString * TCGetDeviceUUID() {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

NSString * TCGetDeviceOSVersion() {
    return [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
}

NSString * TCGetAppIdentifier() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

NSString * TCGetAppVersion() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString * TCGetAppBuildVersion() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

NSString * TCGetAppFullVersion() {
    return [NSString stringWithFormat:@"%@ (Build %@)", TCGetAppVersion(), TCGetAppBuildVersion()];
}

#endif
