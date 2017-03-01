//
//  TCServiceFilterView.h
//  store
//
//  Created by 穆康 on 2017/3/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCServiceFilterType) {
    TCServiceFilterTypeNone = 0,          // 无
    TCServiceFilterTypeReservation,       // 可预订
    TCServiceFilterTypeHome               // 有包间
};

@protocol TCServiceFilterViewDelegate;
@interface TCServiceFilterView : UIView

@property (nonatomic, readonly) TCServiceFilterType filterType;
@property (weak, nonatomic) id<TCServiceFilterViewDelegate> delegate;

@end

@protocol TCServiceFilterViewDelegate <NSObject>

@optional
- (void)serviceFilterView:(TCServiceFilterView *)view didSelectItemViewWithFilterType:(TCServiceFilterType)filterType;

@end
