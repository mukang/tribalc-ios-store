//
//  TCGoodsOrderChangeInfo.h
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 修改商品订单时使用
 */
@interface TCGoodsOrderChangeInfo : NSObject

/** 订单ID */
@property (copy, nonatomic) NSString *orderID;
/** 订单状态 { CANCEL, NO_SETTLE, SETTLE, DELIVERY, RECEIVED } */
@property (copy, nonatomic) NSString *status;
/** 快递单号 */
@property (copy, nonatomic) NSString *logisticsNum;
/** 快递公司 */
@property (copy, nonatomic) NSString *logisticsCompany;

@end
