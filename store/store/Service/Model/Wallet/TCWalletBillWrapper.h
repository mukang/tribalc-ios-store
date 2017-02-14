//
//  TCWalletBillWrapper.h
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWalletBillWrapper : NSObject

/** 当前查询交易类型 */
@property (copy, nonatomic) NSString *tradingType;
/** 当前结果中的前置跳过 */
@property (copy, nonatomic) NSString *prevSkip;
/** 当前结果中的最后跳过规则，可用于下次查询 */
@property (copy, nonatomic) NSString *nextSkip;
/** 是否还有条目待获取 */
@property (nonatomic) BOOL hasMore;
/** 明细列表 */
@property (copy, nonatomic) NSArray *content;

@end
