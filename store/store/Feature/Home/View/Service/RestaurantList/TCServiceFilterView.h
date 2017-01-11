//
//  TCServiceFilterView.h
//  individual
//
//  Created by WYH on 16/12/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCServiceFilterView;
@protocol TCServiceFilterViewDelegate <NSObject>

- (void)filterView:(TCServiceFilterView *)filterView didSelectSortServiceBtn:(NSInteger)type;
- (void)filterView:(TCServiceFilterView *)filterView didSelectFilterServiceBtn:(NSInteger)type;

@end


@interface TCServiceFilterView : UIView

typedef NS_ENUM(NSInteger, TCSortType){
    TCAverageMax,
    TCAverageMin,
    TCEvaluateMax,
    TCPopularityMax,
    TCDistanceMin
};

typedef NS_ENUM(NSInteger, TCFilterType) {
    TCDeliver,
    TCReserve
};

- (void)hiddenAllView;

@property (nonatomic, weak) id<TCServiceFilterViewDelegate> delegate;

@end
