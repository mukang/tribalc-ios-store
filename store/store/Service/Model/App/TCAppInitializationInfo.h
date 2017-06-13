//
//  TCAppInitializationInfo.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCAppVersion;
@class TCPromotions;
@class TCFeatureSwitches;

/**
 应用初始化信息
 */
@interface TCAppInitializationInfo : NSObject

/** 应用配置信息 */
@property (strong, nonatomic) TCAppVersion *app;
/** 推广信息 */
@property (strong, nonatomic) TCPromotions *promotions;
/** 功能开关 */
@property (strong, nonatomic) TCFeatureSwitches *switches;

@end
