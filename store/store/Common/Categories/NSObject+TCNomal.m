//
//  NSObject+TCNomal.m
//  individual
//
//  Created by 王帅锋 on 16/12/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "NSObject+TCNomal.h"
#import <MBProgressHUD.h>

@implementation NSObject (TCNomal)
- (void)btnClickUnifyTips {
    [MBProgressHUD showHUDWithMessage:@"此功能暂未开通，敬请期待！"];
}
@end
