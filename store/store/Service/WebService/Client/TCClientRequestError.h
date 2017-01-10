//
//  TCClientRequestError.h
//  individual
//
//  Created by 穆康 on 2016/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TCClientRequestErrorDomain;
extern NSString *const TCClientRequestOriginErrorDescriptionKey;

typedef NS_ENUM(NSUInteger, TCClientRequestErrorCode) {
    TCClientRequestErrorNetworkError = 10001,
    TCClientRequestErrorNetworkNotConnected,
    TCClientRequestErrorServerResponseNotJSON,
    TCClientRequestErrorServerInternalError,
    TCClientRequestErrorRequestInvalid,
    TCClientRequestErrorNetworkCanceled,
    TCClientRequestErrorUserSessionInvalid,
    TCClientRequestErrorRequestSerializationError
};

/**
 代表客户端请求错误的类，继承NSError
 */
@interface TCClientRequestError : NSError

/**
 初始化一个错误对象

 @param code        错误码
 @param description 原始错误描述

 @return 返回一个TCClientRequestError实例，domain为TCClientRequestError
 */
+ (instancetype)errorWithCode:(TCClientRequestErrorCode)code andDescription:(NSString *)description;

/**
 根据隶属于NSURLErrorDomain的错误码，找到对应的TCClientRequestErrorCode错误码

 @param code NSURLErrorDomain的错误码

 @return TCClientRequestErrorCode错误码
 */
+ (TCClientRequestErrorCode)codeFromNSURLErrorCode:(NSInteger)code;

/**
 获取原始的错误描述

 @return 原始错误描述，NSString对象
 */
- (NSString *)originErrorDescription;

@end
