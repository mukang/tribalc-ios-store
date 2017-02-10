//
//  TCReservationWrapper.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationWrapper.h"
#import "TCReservation.h"

@implementation TCReservationWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCReservation class]};
}

@end
