//
//  TCExtendButton.m
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCExtendButton.h"

@implementation TCExtendButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets slop = self.hitTestSlop;
    if (UIEdgeInsetsEqualToEdgeInsets(slop, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    } else {
        BOOL isInside = CGRectContainsPoint(UIEdgeInsetsInsetRect(self.bounds, slop), point);
        return isInside;
    }
}

@end
