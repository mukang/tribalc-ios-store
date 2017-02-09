//
//  TCGoodsStandardKeysBtn.m
//  store
//
//  Created by 王帅锋 on 17/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardKeysBtn.h"

@implementation TCGoodsStandardKeysBtn

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    /**
     *  此注释掉的方法用来判断点击是否在父View Bounds内，
     *  如果不在父view内，就会直接不会去其子View中寻找HitTestView，return 返回
     */
    //if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    //}
    return nil;
}

@end
