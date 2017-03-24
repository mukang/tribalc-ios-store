//
//  TCClientResponse.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCClientResponse : NSObject

/** HTTP状态码 */
@property (nonatomic, readonly) NSInteger statusCode;
/** 数据库返回数据中的状态码 */
@property (nonatomic, readonly) NSInteger codeInResponse;

@property (copy, nonatomic, readonly) id data;
@property (strong, nonatomic, readonly) NSError *error;

+ (instancetype)responseWithStatusCode:(NSInteger)statusCode codeInResponse:(NSInteger)codeInResponse data:(id)data orError:(NSError *)error;

@end
