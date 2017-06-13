//
//  TCFeatureSwitches.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 功能开关
 */
@interface TCFeatureSwitches : NSObject

/** 充值功能 */
@property (nonatomic) BOOL bf_recharge;
/** 提现功能 */
@property (nonatomic) BOOL bf_withdraw;

@end
