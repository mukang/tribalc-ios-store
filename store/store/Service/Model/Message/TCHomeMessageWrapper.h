//
//  TCHomeMessageWrapper.h
//  individual
//
//  Created by 穆康 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCHomeMessage.h"

@interface TCHomeMessageWrapper : NSObject

@property (nonatomic) BOOL hasMore;

@property (copy, nonatomic) NSArray *content;

@end
