//
//  TCHomeMessage.h
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHomeMessageBody.h"

@interface TCHomeMessage : NSObject

/** id */
@property (copy, nonatomic) NSString *ID;
/** 消息创建日期 */
@property (nonatomic) int64_t createDate;
/** 消息过期日期 */
@property (nonatomic) int64_t expireDate;
/** 首页消息体 */
@property (strong, nonatomic) TCHomeMessageBody *messageBody;
/** 拥有者，为 null 时为公共消息 */
@property (copy, nonatomic) NSString *ownerId;
/** 是否过期 */
@property (nonatomic) BOOL expire;

@end
