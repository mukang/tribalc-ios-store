//
//  TCStoreCategoryInfo.h
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCStoreCategoryInfo : NSObject

/** 图标 */
@property (copy, nonatomic) NSString *icon;
/** 种类名称 */
@property (copy, nonatomic) NSString *name;
/** 种类 */
@property (copy, nonatomic) NSString *category;

@end
