//
//  TCHomeMessage.m
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessage.h"

@implementation TCHomeMessage

+ (NSDictionary *)objectClassInArray {
    return @{@"messageBody": [TCHomeMessageBody class]};
}

@end
