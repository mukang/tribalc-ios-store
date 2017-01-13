//
//  TCGetPasswordView.h
//  individual
//
//  Created by 穆康 on 2016/10/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCGetPasswordView;

@protocol TCGetPasswordViewDelegate <NSObject>

@optional
- (void)didTapGetPasswordButtonInGetPasswordView:(TCGetPasswordView *)view;

@end

@interface TCGetPasswordView : UIView

@property (nonatomic, weak) id<TCGetPasswordViewDelegate> delegate;

/**
 开始倒计时
 */
- (void)startCountDown;

/**
 停止倒计时
 */
- (void)stopCountDown;

@end
