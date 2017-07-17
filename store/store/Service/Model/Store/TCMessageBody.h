//
//  TCMessageBody.h
//  store
//
//  Created by 王帅锋 on 2017/7/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TCMODEL_SYSTEM_VARIABLES_MAP @{@"descriptionStr":@"description"}

@interface TCMessageBody : NSObject

@property (copy, nonatomic) NSString *homeMessageType;

@property (copy, nonatomic) NSString *body;

@property (copy, nonatomic) NSString *descriptionStr;

@property (copy, nonatomic) NSString *remark;

@end
