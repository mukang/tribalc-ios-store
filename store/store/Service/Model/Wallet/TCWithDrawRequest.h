//
//  TCWithDrawRequest.h
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWithDrawRequest : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *ownerId;

@property (assign, nonatomic) int64_t createTime;

@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *bankcardNum;

@property (assign, nonatomic) CGFloat amount;

@end
