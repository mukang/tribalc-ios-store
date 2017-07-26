//
//  TCPrivilegeWrapper.m
//  store
//
//  Created by 王帅锋 on 2017/7/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeWrapper.h"
#import "TCPrivilege.h"

@implementation TCPrivilegeWrapper

+ (NSDictionary *)objectClassInArray {
    return @{
             @"privileges": [TCPrivilege class]
             };
}

@end
