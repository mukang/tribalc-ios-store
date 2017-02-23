//
//  TCServiceWrapper.m
//  individual
//
//  Created by WYH on 16/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceWrapper.h"
#import "TCService.h"

@implementation TCServiceWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCService class]};
}

@end
