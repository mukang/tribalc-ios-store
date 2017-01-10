//
//  TCClient.h
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCFunctions.h"
#import "TCClientRequest.h"
#import "TCClientResponse.h"
#import "TCClientRequestError.h"

@interface TCClient : NSObject

/**
 单例

 @return 返回配置好的client
 */
+ (instancetype)client;

/**
 发送网络请求

 @param clientRequest TCClientRequest对象
 @param responseBlock 响应结果回调
 */
- (void)send:(TCClientRequest *)clientRequest
      finish:(void (^)(TCClientResponse *response))responseBlock;

/**
 上传文件

 @param clientRequest TCClientRequest对象
 @param progress 上传进度
 @param responseBlock 响应结果回调
 */
- (void)upload:(TCClientRequest *)clientRequest
      progress:(void (^)(NSProgress *progress))progress
        finish:(void (^)(TCClientResponse *response))responseBlock;

@end
