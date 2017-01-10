//
//  TCClientRequest.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClientRequest.h"
#import "TCFunctions.h"
#import "TCClientConfig.h"

NSString *const TCClientHTTPMethodGet = @"GET";
NSString *const TCClientHTTPMethodPost = @"POST";
NSString *const TCClientHTTPMethodPut = @"PUT";
NSString *const TCClientHTTPMethodDelete = @"DELETE";

@interface TCClientRequest ()

@property (nonatomic, strong) NSMutableDictionary *requestParams;

@end

@implementation TCClientRequest

#pragma mark - Protocol DXClientRequest

- (void)setValue:(id)value forParam:(NSString *)name {
    if (name != nil && value != nil) {
        [self.requestParams setObject:value forKey:name];
    }
}

- (id)valueForParam:(NSString *)name {
    return [self.requestParams objectForKey:name];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [self setValue:value forParam:key];
}

- (id)valueForKey:(NSString *)key {
    return [self valueForParam:key];
}

- (id)params {
    if (_params) {
        return _params;
    }
    if (_requestParams) {
        return [_requestParams copy];
    }
    return nil;
}

#pragma mark - Public Methods

+ (instancetype)requestWithApi:(NSString *)apiName {
    return [[self class] requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
}

+ (instancetype)requestWithHTTPMethod:(NSString *)HTTPMethod apiName:(NSString *)apiName {
    if (!HTTPMethod) HTTPMethod = TCClientHTTPMethodGet;
    return [[self alloc] initWithHTTPMethod:HTTPMethod apiName:apiName];
}

+ (instancetype)requestWithHTTPMethod:(NSString *)HTTPMethod uploadURLString:(NSString *)URLString {
    if (!HTTPMethod) HTTPMethod = TCClientHTTPMethodPut;
    return [[self alloc] initWithHTTPMethod:HTTPMethod uploadURLString:URLString];
}

#pragma mark - Private Methods

- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod apiName:(NSString *)apiName {
    NSParameterAssert(HTTPMethod);
    NSParameterAssert(apiName);
    NSAssert(![apiName hasPrefix:@"/"], @"apiName（%@）不能以“/”开头", apiName);
    if (self = [super init]) {
        _HTTPMethod = HTTPMethod;
        _apiName = apiName;
        _requestIdentifier = [[self class] createIdentifier];
    }
    return self;
}

- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod uploadURLString:(NSString *)URLString {
    NSParameterAssert(HTTPMethod);
    NSParameterAssert(URLString);
    if (self = [super init]) {
        _HTTPMethod = HTTPMethod;
        _uploadURLString = URLString;
        _requestIdentifier = [[self class] createIdentifier];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCClientRequest初始化错误"
                                   reason:@"请使用接口文件提供的类方法"
                                 userInfo:nil];
    return nil;
}

+ (NSString *)createIdentifier {
    NSDate *now = [NSDate date];
    int random = arc4random() % 1000;
    NSString *randomString = [NSString stringWithFormat:@"%lu%03d", (unsigned long)[now timeIntervalSince1970], random];
    return TCDigestMD5(randomString);
}

#pragma mark - Override Methods

- (NSMutableDictionary *)requestParams {
    if (_requestParams == nil) {
        _requestParams = [NSMutableDictionary dictionary];
    }
    return _requestParams;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"request: %@ apiName: %@ HTTPMethod: %@ params: %@", [self class], self.apiName, self.HTTPMethod, self.params];
}

@end
