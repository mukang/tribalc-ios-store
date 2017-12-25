//
//  TCNavigationBar.m
//  individual
//
//  Created by 穆康 on 2017/9/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCNavigationBar.h"

@implementation TCNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        NSString *subviewName = NSStringFromClass([subview class]);
        if ([subviewName containsString:@"UIBarBackground"]) {
            subview.frame = self.bounds;
        } else if ([subviewName containsString:@"UINavigationBarContentView"]) {
            if (subview.height < 64) {
                subview.y = 64 - subview.height;
            } else {
                subview.y = 0;
            }
        }
    }
}

@end
