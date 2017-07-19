//
//  TCHomeMessageBody.h
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHomeMessageType.h"

@interface TCHomeMessageBody : NSObject

/** 消息类型枚举 */
@property (strong, nonatomic) TCHomeMessageType *homeMessageType;
/** 消息主体 */
@property (copy, nonatomic) NSString *body;
/** 消息描述 */
@property (copy, nonatomic) NSString *description;
/** 还款日期 */
@property (nonatomic) int64_t repaymentTime;
/** 还款金额 */
@property (nonatomic) double repaymentAmount;
/** 还款周期 */
@property (nonatomic) NSInteger periodicity;
/** 关联信息ID */
@property (copy, nonatomic) NSString *referenceId;

@end
