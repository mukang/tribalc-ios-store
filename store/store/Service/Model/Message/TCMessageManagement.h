//
//  TCMessageManagement.h
//  individual
//
//  Created by 穆康 on 2017/8/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHomeMessageType.h"

/**
 消息管理
 */
@interface TCMessageManagement : NSObject

/** 消息类型 */
@property (strong, nonatomic) TCHomeMessageType *messageTypeView;
/** 消息类型开关 */
@property (nonatomic) BOOL isOpen;

@end
