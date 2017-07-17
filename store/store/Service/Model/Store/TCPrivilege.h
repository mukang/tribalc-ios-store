//
//  TCPrivilege.h
//  store
//
//  Created by 王帅锋 on 2017/7/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPrivilege : NSObject

/** 优惠id */
@property (copy, nonatomic) NSString *ID;
/** 优惠类型 */
@property (copy, nonatomic) NSString *type;
/** 要满足的金额 */
@property (assign, nonatomic) double condition;
/** 折扣或满减金额 */
@property (assign, nonatomic) double value;
/** 商户ID */
@property (copy, nonatomic) NSString *ownerId;
/** 可用时段 */
@property (copy, nonatomic) NSArray *activityTime;
/** 开始时间 */
@property (assign, nonatomic) NSInteger startDate;
/** 结束时间 */
@property (assign, nonatomic) NSInteger endDate;

@end
