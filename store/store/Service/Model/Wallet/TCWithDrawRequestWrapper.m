//
//  TCWithDrawRequestWrapper.m
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithDrawRequestWrapper.h"
#import "TCWithDrawRequest.h"

@implementation TCWithDrawRequestWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCWithDrawRequest class]};
}

@end
