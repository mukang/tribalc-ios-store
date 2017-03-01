//
//  TCServiceTabBar.h
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCServiceSortView.h"
#import "TCServiceFilterView.h"

@protocol TCServiceTabBarDelegate;
@interface TCServiceTabBar : UIView

@property (weak, nonatomic) TCServiceSortView *sortView;
@property (weak, nonatomic) TCServiceFilterView *filterView;

@property (weak, nonatomic) id<TCServiceTabBarDelegate> delegate;
- (instancetype)initWithController:(UIViewController *)controller;

@end

@protocol TCServiceTabBarDelegate <NSObject>

@optional
- (void)serviceTabBar:(TCServiceTabBar *)tabBar didSelectItemViewWithSortType:(TCServiceSortType)sortType filterType:(TCServiceFilterType)filterType;

@end
