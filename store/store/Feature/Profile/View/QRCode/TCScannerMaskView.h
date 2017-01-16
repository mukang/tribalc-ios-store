//
//  TCScannerMaskView.h
//  individual
//
//  Created by 王帅锋 on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCScannerMaskView : UIView
/// 使用裁切区域实例化遮罩视图
///
/// @param frame    视图区域
/// @param cropRect 裁切区域
///
/// @return 遮罩视图
+ (instancetype)maskViewWithFrame:(CGRect)frame cropRect:(CGRect)cropRect;

/// 裁切区域
@property (nonatomic) CGRect cropRect;
@end
