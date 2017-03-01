//
//  TCServiceSortView.h
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCServiceSortType) {
    TCServiceSortTypeNone = 0,          // 无
    TCServiceSortTypePerCapitaAsc,      // 人均最低
    TCServiceSortTypePerCapitaDesc,     // 人均最高
    TCServiceSortTypePopularityDesc,    // 人气最高
    TCServiceSortTypeLocationAsc,       // 离我最近
    TCServiceSortTypeEvaluationDesc     // 评价最高
};

@protocol TCServiceSortViewDelegate;
@interface TCServiceSortView : UIView

@property (nonatomic, readonly) TCServiceSortType sortType;
@property (weak, nonatomic) id<TCServiceSortViewDelegate> delegate;

@end

@protocol TCServiceSortViewDelegate <NSObject>

@optional
- (void)serviceSortView:(TCServiceSortView *)view didSelectItemViewWithSortType:(TCServiceSortType)sortType;

@end
