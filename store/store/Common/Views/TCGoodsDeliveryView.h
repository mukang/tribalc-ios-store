//
//  TCGoodsDeliveryView.h
//  store
//
//  Created by 穆康 on 2017/2/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCGoodsDeliveryViewDelegate;

@interface TCGoodsDeliveryView : UIView

@property (weak, nonatomic) id<TCGoodsDeliveryViewDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;
- (void)dismiss;

@end

@protocol TCGoodsDeliveryViewDelegate <NSObject>

@optional
- (void)goodsDeliveryView:(TCGoodsDeliveryView *)view didClickDeliveryButtonWithLogisticsCompany:(NSString *)company logisticsNum:(NSString *)num;

@end
