//
//  TCClientRequestError.m
//  individual
//
//  Created by 穆康 on 2016/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClientRequestError.h"

NSString *const TCClientRequestErrorDomain = @"TCClientRequestErrorDomain";
NSString *const TCClientRequestOriginErrorDescriptionKey = @"TCClientRequestOriginErrorDescriptionKey";

@implementation TCClientRequestError

+ (instancetype)errorWithCode:(TCClientRequestErrorCode)code andDescription:(NSString *)description {
    NSDictionary *userInfo = description ? @{TCClientRequestOriginErrorDescriptionKey : description} : nil;
    return [[self alloc] initWithDomain:TCClientRequestErrorDomain
                                   code:code
                               userInfo:userInfo];
}

+ (TCClientRequestErrorCode)codeFromNSURLErrorCode:(NSInteger)code {
    TCClientRequestErrorCode simplifiedCode = TCClientRequestErrorNetworkError;
    switch (code) {
        case NSURLErrorNotConnectedToInternet:
            simplifiedCode = TCClientRequestErrorNetworkNotConnected;
            break;
        case NSURLErrorCancelled:
        case NSURLErrorUserCancelledAuthentication:
            simplifiedCode = TCClientRequestErrorNetworkCanceled;
            break;
        case NSURLErrorBadURL:
        case NSURLErrorUnsupportedURL:
        case NSURLErrorHTTPTooManyRedirects:
        case NSURLErrorRedirectToNonExistentLocation:
        case NSURLErrorBadServerResponse:
        case NSURLErrorUserAuthenticationRequired:
        case NSURLErrorCannotDecodeRawData:
        case NSURLErrorCannotDecodeContentData:
        case NSURLErrorCannotParseResponse:
            simplifiedCode = TCClientRequestErrorServerInternalError;
            break;
        case NSURLErrorCannotFindHost:
        case NSURLErrorZeroByteResource:
        default:
            break;
    }
    return simplifiedCode;
}

+ (NSDictionary *)errorDefinitions {
    return @{
             @(TCClientRequestErrorNetworkError)              : @"网络状况不佳",
             @(TCClientRequestErrorNetworkNotConnected)       : @"互联网未连接",
             @(TCClientRequestErrorNetworkCanceled)           : @"已取消网络请求",
             @(TCClientRequestErrorServerResponseNotJSON)     : @"服务器响应格式不正确",
             @(TCClientRequestErrorServerInternalError)       : @"服务器出错",
             @(TCClientRequestErrorRequestInvalid)            : @"无效的请求",
             @(TCClientRequestErrorUserSessionInvalid)        : @"用户未登录或需要重新登录",
             @(TCClientRequestErrorRequestSerializationError) : @"请求序列化错误"
             };
}

+ (NSDictionary *)errorComments {
    return @{
             @(TCClientRequestErrorNetworkError)              : @"Network Error",
             @(TCClientRequestErrorNetworkNotConnected)       : @"Network Not Connected",
             @(TCClientRequestErrorNetworkCanceled)           : @"Network Request Canceled",
             @(TCClientRequestErrorServerResponseNotJSON)     : @"Remover Server Response Format Is Wrong",
             @(TCClientRequestErrorServerInternalError)       : @"Remote Server Error",
             @(TCClientRequestErrorRequestInvalid)            : @"Request Invalid",
             @(TCClientRequestErrorUserSessionInvalid)        : @"User Needs To Login",
             @(TCClientRequestErrorRequestSerializationError) : @"Request Serialization Error"
             };
}

- (NSString *)localizedDescription {
    if ([self.userInfo objectForKey:TCClientRequestOriginErrorDescriptionKey]) {
        return [self.userInfo objectForKey:TCClientRequestOriginErrorDescriptionKey];
    } else {
        NSDictionary *errorDefinitions = [[self class] errorDefinitions];
        return [errorDefinitions objectForKey:@(self.code)];
    }
}

- (NSString *)originErrorDescription {
    return [self.userInfo objectForKey:TCClientRequestOriginErrorDescriptionKey];
}

@end
