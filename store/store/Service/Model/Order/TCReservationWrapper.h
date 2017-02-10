//
//  TCReservationWrapper.h
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCReservationWrapper : NSObject

/** 当前状态，默认全部 */
@property (copy, nonatomic) NSString *status;
/** 当前结果中的前置跳过 */
@property (copy, nonatomic) NSString *prevSkip;
/** 当前结果中的最后跳过规则，可用于下次查询 */
@property (copy, nonatomic) NSString *nextSkip;
/** 是否还有条目待获取 */
@property (nonatomic) BOOL hasMore;
/** 商品列表，TCReservation对象数组 */
@property (copy, nonatomic) NSArray *content;

@end
