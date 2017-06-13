//
//  TCPromotions.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 推广信息
 */
@interface TCPromotions : NSObject

/** 图片URL */
@property (copy, nonatomic) NSString *url;
/** 图片点击后指令信息 */
@property (copy, nonatomic) NSString *router;
/** 是否可跳过 */
@property (nonatomic) BOOL canSkip;
/** 自动跳过秒数 */
@property (nonatomic) NSInteger skipSeconds;

/** 推广开始时间 */
@property (nonatomic) long long startTime;
/** 推广结束时间 */
@property (nonatomic) long long endTime;

@end
