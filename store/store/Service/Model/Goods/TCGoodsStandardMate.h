//
//  TCGoodsStandardMate.h
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCGoodsStandardDescriptions;

@interface TCGoodsStandardMate : NSObject

@property (copy, nonatomic) NSString *title;

@property (strong, nonatomic) TCGoodsStandardDescriptions *descriptions;

@property (copy, nonatomic) NSDictionary *priceAndRepertoryMap;

@end
