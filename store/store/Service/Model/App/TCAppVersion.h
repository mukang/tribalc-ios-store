//
//  TCAppVersion.h
//  individual
//
//  Created by 穆康 on 2017/5/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAppVersion : NSObject

/** 最新版本号 */
@property (copy, nonatomic) NSString *lastVersion;
/** 支持最小版本号 */
@property (copy, nonatomic) NSString *minVersion;
/** 更新日志 */
@property (copy, nonatomic) NSArray *releaseNote;

@end
