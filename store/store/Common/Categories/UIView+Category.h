//
//  UIView+Category.h
//  individual
//
//  Created by 穆康 on 2016/10/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

/** x值 */
@property (assign, nonatomic) CGFloat x;

/** y值 */
@property (assign, nonatomic) CGFloat y;

/** 宽 */
@property (assign, nonatomic) CGFloat width;

/** 高 */
@property (assign, nonatomic) CGFloat height;

/** 中心x值 */
@property (assign, nonatomic) CGFloat centerX;

/** 中心y值 */
@property (assign, nonatomic) CGFloat centerY;

/** 原点 */
@property (assign, nonatomic) CGPoint origin;

/** 尺寸 */
@property (assign, nonatomic) CGSize size;

@end
