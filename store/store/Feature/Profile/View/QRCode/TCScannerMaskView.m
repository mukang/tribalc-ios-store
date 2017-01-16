//
//  TCScannerMaskView.m
//  individual
//
//  Created by 王帅锋 on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCScannerMaskView.h"

@implementation TCScannerMaskView

+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect {
    
    TCScannerMaskView *maskView = [[self alloc] initWithFrame:frame];
    
    maskView.backgroundColor = [UIColor clearColor];
    maskView.cropRect = cropRect;
    
    return maskView;
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    [[UIColor colorWithWhite:0.0 alpha:0.4] setFill];
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] setFill];
    CGContextFillRect(ctx, rect);
    
    CGContextClearRect(ctx, self.cropRect);
    
//    [[UIColor colorWithWhite:0.95 alpha:1.0] setStroke];
//    [[UIColor colorWithWhite:0 alpha:1.0] setStroke];
    CGContextStrokeRectWithWidth(ctx, CGRectInset(_cropRect, 1, 1), 1);
}

@end
