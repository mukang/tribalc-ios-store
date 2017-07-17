//
//  TCMessage.h
//  store
//
//  Created by 王帅锋 on 2017/7/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCMessageBody.h"

@interface TCMessage : NSObject

@property (copy, nonatomic) NSString *ID;

@property (assign, nonatomic) NSInteger createDate;

@property (assign, nonatomic) NSInteger expireDate;

@property (copy, nonatomic) NSString *ownerId;

@property (assign, nonatomic) BOOL expire;

@property (strong, nonatomic) TCMessageBody *messageBody;

@end
