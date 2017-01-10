//
//  TCGoodStandards.h
//  individual
//
//  Created by WYH on 16/11/24.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoodStandards : NSObject

/** 商品规格ID */
@property (copy, nonatomic) NSString *ID;
/** 规格描述信息 */
@property (copy, nonatomic) NSDictionary *descriptions;
/** 规格索引信息 */
@property (copy, nonatomic) NSDictionary *goodsIndexes;

@end
