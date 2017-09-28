//
//  TCGoodsRefundView.h
//  store
//
//  Created by 穆康 on 2017/9/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCGoodsRefundViewDelegate;
@interface TCGoodsRefundView : UIView

@property (weak, nonatomic) id<TCGoodsRefundViewDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;
- (void)dismiss;
- (void)dismissCompletion:(void (^)())completion;

@end

@protocol TCGoodsRefundViewDelegate <NSObject>

@optional
- (void)goodsRefundView:(TCGoodsRefundView *)view didClickRefundButtonWithReason:(NSString *)reason;

@end
