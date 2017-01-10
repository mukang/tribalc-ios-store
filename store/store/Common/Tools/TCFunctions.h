//
//  TCFunctions.h
//  individual
//
//  Created by 穆康 on 2016/10/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _TCFunctions_h
#define _TCFunctions_h



#pragma mark - NSString 操作

/**
 *  计算字符串的MD5摘要
 *
 *  @param text 需要计算MD5摘要的NSString字符串
 *
 *  @return 返回已计算的MD5摘要，为32个小写字符
 */
extern NSString * TCDigestMD5(NSString * text);

/**
 计算二进制数据的MD5摘要

 @param data 需要计算MD5摘要的二进制数据
 @return 返回已计算的MD5摘要，为32个小写字符
 */
extern NSString * TCDigestMD5ToData(NSData *data);


#pragma mark - 线程操作

#ifndef TC_CALL_ASYNC_MQ
#define TC_CALL_ASYNC_MQ(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ ;})
#endif

#ifndef TC_CALL_ASYNC_GQ_HIGH
#define TC_CALL_ASYNC_GQ_HIGH(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ __VA_ARGS__ ;})
#endif

#ifndef TC_CALL_ASYNC_GQ_DEFAULT
#define TC_CALL_ASYNC_GQ_DEFAULT(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ __VA_ARGS__ ;})
#endif

#ifndef TC_CALL_ASYNC_GQ_LOW
#define TC_CALL_ASYNC_GQ_LOW(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ __VA_ARGS__ ;})
#endif

#ifndef TC_CALL_ASYNC_GQ_BACKGROUND
#define TC_CALL_ASYNC_GQ_BACKGROUND(...) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{ __VA_ARGS__ ;})
#endif

#ifndef TC_CALL_ASYNC_Q
#define TC_CALL_ASYNC_Q(queue, ...) dispatch_async(queue, ^{ __VA_ARGS__ ;})
#endif



#pragma mark - 设备操作

extern NSString * TCGetDeviceModel();

extern NSString * TCGetDeviceUUID();

extern NSString * TCGetDeviceOSVersion();

extern NSString * TCGetAppIdentifier();

extern NSString * TCGetAppVersion();

extern NSString * TCGetAppBuildVersion();

extern NSString * TCGetAppFullVersion();

#endif
