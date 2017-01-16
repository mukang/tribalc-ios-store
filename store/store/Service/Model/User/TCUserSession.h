//
//  TCUserSession.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCStoreInfo;

/** 已登录用户的session */
@interface TCUserSession : NSObject 

/** 用户ID */
@property (copy, nonatomic) NSString *assigned;
/** TOKEN字符串 */
@property (copy, nonatomic) NSString *token;
/** TOKEN有效截止时间(毫秒) */
@property (nonatomic) NSInteger expired;

@property (strong, nonatomic) TCStoreInfo *storeInfo;

@end
