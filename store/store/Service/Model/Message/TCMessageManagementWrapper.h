//
//  TCMessageManagementWrapper.h
//  individual
//
//  Created by 穆康 on 2017/9/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCMessageManagement.h"

@interface TCMessageManagementWrapper : NSObject

/** 本身包含的消息类型 */
@property (copy, nonatomic) NSArray *primary;
/** 附加消息类型，如企业代理人拥有部分企业办公消息 */
@property (copy, nonatomic) NSArray *additional;

@end
