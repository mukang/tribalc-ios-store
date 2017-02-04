//
//  TCStoreSetMealCreation.h
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 创建服务信息
 */
@interface TCStoreSetMealCreation : NSObject

/** 服务ID */
@property (copy, nonatomic) NSString *ID;
/** 服务名称 */
@property (copy, nonatomic) NSString *name;
/** 服务环境图 */
@property (copy, nonatomic) NSArray *pictures;
/** 服务话题 */
@property (copy, nonatomic) NSString *topics;
/** 推荐理由 */
@property (copy, nonatomic) NSString *recommendedReason;
/** 人均消费 */
@property (nonatomic) NSInteger personExpense;
/** 服务是否接受预定 */
@property (nonatomic) BOOL isReservable;

@end
