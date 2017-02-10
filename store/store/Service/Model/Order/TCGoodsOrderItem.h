//
//  TCGoodsOrderItem.h
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCGoods;

/**
 订单产品项 
 */
@interface TCGoodsOrderItem : NSObject

/** 产品数量 */
@property (nonatomic) NSInteger amount;
/** 产品信息 */
@property (strong, nonatomic) TCGoods *goods;

@end
