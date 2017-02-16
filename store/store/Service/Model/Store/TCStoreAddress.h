//
//  TCStoreAddress.h
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCStoreAddress : NSObject

/** 省 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 区域 */
@property (copy, nonatomic) NSString *district;
/** 详细地址 */
@property (copy, nonatomic) NSString *address;
/** 位置信息 */
@property (copy, nonatomic) NSArray *coordinate;

@end
