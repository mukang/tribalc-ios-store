//
//  TCClientRequest.h
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TCClientHTTPMethodGet;
extern NSString *const TCClientHTTPMethodPost;
extern NSString *const TCClientHTTPMethodPut;
extern NSString *const TCClientHTTPMethodDelete;

@protocol TCClientRequest <NSObject>

@required

- (void)setValue:(id)value forParam:(NSString *)name;

- (id)valueForParam:(NSString *)name;

@end


@interface TCClientRequest : NSObject <TCClientRequest>

/** 用户token，必填 */
@property (copy, nonatomic) NSString *token;
/** 参数 */
@property (strong, nonatomic) id params;
/** 图片上传时的图片数据 */
@property (strong, nonatomic) NSData *imageData;

@property (copy, nonatomic, readonly) NSString *apiName;
@property (copy, nonatomic, readonly) NSString *uploadURLString;
@property (copy, nonatomic, readonly) NSString *HTTPMethod;
@property (copy, nonatomic, readonly) NSString *requestIdentifier;

+ (instancetype)requestWithApi:(NSString *)apiName;
+ (instancetype)requestWithHTTPMethod:(NSString *)HTTPMethod apiName:(NSString *)apiName;
+ (instancetype)requestWithHTTPMethod:(NSString *)HTTPMethod uploadURLString:(NSString *)URLString;

@end


