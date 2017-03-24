//
//  TCClientResponse.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClientResponse.h"
#import <objc/runtime.h>

@implementation TCClientResponse

#pragma mark - Public Methods

+ (instancetype)responseWithStatusCode:(NSInteger)statusCode codeInResponse:(NSInteger)codeInResponse data:(id)data orError:(NSError *)error {
    if (!error) {
        return [[self alloc] initWithStatusCode:statusCode codeInResponse:codeInResponse data:data];
    } else {
        return [[self alloc] initWithStatusCode:statusCode codeInResponse:codeInResponse error:error];
    }
}

#pragma mark - Private Methods

- (instancetype)initWithStatusCode:(NSInteger)statusCode codeInResponse:(NSInteger)codeInResponse data:(id)data {
    if (self = [super init]) {
        _statusCode = statusCode;
        _codeInResponse = codeInResponse;
        _data = data;
    }
    return self;
}

- (instancetype)initWithStatusCode:(NSInteger)statusCode codeInResponse:(NSInteger)codeInResponse error:(NSError *)error {
    if (self = [super init]) {
        _statusCode = statusCode;
        _codeInResponse = codeInResponse;
        _error = error;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCClientResponse初始化错误"
                                   reason:@"请使用接口文件提供的类方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Override Methods

- (NSString *)description {
    id info = self.error ?: self.data;
    return [NSString stringWithFormat:@"%@ : (%zd) %@", [self class], self.statusCode, info];
}

@end
