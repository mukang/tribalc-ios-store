//
//  TCClientResponse.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCClientResponse : NSObject

@property (copy, nonatomic, readonly) id data;
@property (strong, nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSInteger statusCode;

+ (instancetype)responseWithStatusCode:(NSInteger)statusCode data:(id)data orError:(NSError *)error;

@end
