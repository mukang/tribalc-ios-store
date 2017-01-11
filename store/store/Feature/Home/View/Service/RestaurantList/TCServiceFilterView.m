//
//  TCServiceFilterView.m
//  individual
//
//  Created by WYH on 16/12/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceFilterView.h"
#import "TCServiceSelectBtn.h"
#import "TCRestaurantSortView.h"
#import "TCRestaurantFilterView.h"
#import "TCSelectSortButton.h"


@implementation TCServiceFilterView {
    TCServiceSelectBtn *sortBtn;
    TCServiceSelectBtn *filterBtn;
    TCRestaurantSortView *sortView;
    TCRestaurantFilterView *filterView;
    UIView *backView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createBackView];
        
        [self createSortAndFilterBtn];
        
        [self createSortView];
        
        [self createFilterView];
        
        
    }
    
    return self;
}

#pragma mark - UI
- (void)createBackView {
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + self.height, TCScreenWidth, TCScreenHeight - self.y - self.height)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = TCARGBColor(0, 0, 0, 0.7);
    backView.hidden = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAllView)];
    [backView addGestureRecognizer:recognizer];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
}

- (void)createSortView {
    sortView = [[TCRestaurantSortView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(179))];
    sortView.hidden = YES;
    [sortView.averageMaxBtn addTarget:self action:@selector(touchSortAverageMaxBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sortView.averageMinBtn addTarget:self action:@selector(touchSortAverageMinBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sortView.evaluateMaxBtn addTarget:self action:@selector(touchSortEvaluateMaxBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sortView.popularityMaxBtn addTarget:self action:@selector(touchSortPopularityMaxBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sortView.distanceMinBtn addTarget:self action:@selector(touchSortDistanceMinBtn:) forControlEvents:UIControlEventTouchUpInside];

    [backView addSubview:sortView];
}

- (void)createFilterView {
    filterView = [[TCRestaurantFilterView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(105))];
    filterView.hidden = YES;
    [filterView.deliverBtn addTarget:self action:@selector(touchFilterDeliverBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterView.reserveBtn addTarget:self action:@selector(touchFilterReserveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:filterView];
}

- (void)createSortAndFilterBtn {
    sortBtn = [[TCServiceSelectBtn alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth / 2, TCRealValue(42)) AndText:@"智能排序" AndImgName:@"res_select_down"];
    [sortBtn addTarget:self action:@selector(touchSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sortBtn];
    filterBtn = [[TCServiceSelectBtn alloc] initWithFrame:CGRectMake(TCScreenWidth / 2, 0, TCScreenWidth / 2, TCRealValue(42)) AndText:@"筛选" AndImgName:@"res_select_down"];
    [filterBtn addTarget:self action:@selector(touchFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(TCScreenWidth / 2 - TCRealValue(1 / 2), self.height / 2 - TCRealValue(13 / 2), TCRealValue(1), TCRealValue(13))];
    lineView.backgroundColor = TCRGBColor(242, 242, 242);
    [self addSubview:lineView];

}


#pragma mark - Touch Action
- (void)touchSortBtn:(TCServiceSelectBtn *)btn {
    if (btn.isSelected) {
        [self hiddenAllView];
    } else {
        [self showSortView];
    }
}

- (void)touchFilterBtn:(TCServiceSelectBtn *)btn {
    if (btn.isSelected) {
        [self hiddenAllView];
    } else {
        [self showFilterView];
    }
}

- (void)touchSortAverageMaxBtn:(TCSelectSortButton *)btn {
    [self setupSortViewButton];
    btn.isSelected = YES;
    
    [self touchSortViewButtonWithButtonType:TCAverageMax];
}
- (void)touchSortAverageMinBtn:(TCSelectSortButton *)btn {
    [self setupSortViewButton];
    btn.isSelected = YES;
    [self touchSortViewButtonWithButtonType:TCAverageMin];

}
- (void)touchSortEvaluateMaxBtn:(TCSelectSortButton *)btn {
    [self setupSortViewButton];
    btn.isSelected = YES;
    [self touchSortViewButtonWithButtonType:TCEvaluateMax];

}
- (void)touchSortPopularityMaxBtn:(TCSelectSortButton *)btn {
    [self setupSortViewButton];
    btn.isSelected = YES;
    [self touchSortViewButtonWithButtonType:TCPopularityMax];

}
- (void)touchSortDistanceMinBtn:(TCSelectSortButton *)btn {
    [self setupSortViewButton];
    btn.isSelected = YES;
    [self touchSortViewButtonWithButtonType:TCDistanceMin];

}

- (void)touchFilterReserveBtn:(TCSelectSortButton *)btn {
    filterView.reserveBtn.isSelected = NO;
    filterView.deliverBtn.isSelected = NO;
    btn.isSelected = YES;
    [self touchFilterViewButtonWithButtonType:TCReserve];
}

- (void)touchFilterDeliverBtn:(TCSelectSortButton *)btn {
    filterView.reserveBtn.isSelected = NO;
    filterView.deliverBtn.isSelected = NO;
    btn.isSelected = YES;
    [self touchFilterViewButtonWithButtonType:TCDeliver];
}

- (void)touchSortViewButtonWithButtonType:(NSInteger)type {
    if (_delegate && [_delegate respondsToSelector:@selector(filterView:didSelectSortServiceBtn:)]) {
        [_delegate filterView:self didSelectSortServiceBtn:type];
    }
    [self hiddenAllView];
}

- (void)touchFilterViewButtonWithButtonType:(NSInteger)type {
    if (_delegate && [_delegate respondsToSelector:@selector(filterView:didSelectFilterServiceBtn:)]) {
        [_delegate filterView:self didSelectFilterServiceBtn:type];
    }
    [self hiddenAllView];
}

#pragma mark - Hidden View
- (void)setupSortViewButton {
    sortView.distanceMinBtn.isSelected = NO;
    sortView.popularityMaxBtn.isSelected = NO;
    sortView.evaluateMaxBtn.isSelected = NO;
    sortView.averageMinBtn.isSelected = NO;
    sortView.averageMaxBtn.isSelected = NO;
}

- (void)showSortView {
    sortView.hidden = NO;
    filterView.hidden = YES;
    backView.hidden = NO;
    sortBtn.isSelected = YES;
    filterBtn.isSelected = NO;
}

- (void)showFilterView {
    sortView.hidden = YES;
    filterView.hidden = NO;
    backView.hidden = NO;
    sortBtn.isSelected = NO;
    filterBtn.isSelected = YES;
}

- (void)hiddenAllView {
    backView.hidden = YES;
    sortView.hidden = YES;
    filterView.hidden = YES;
    sortBtn.isSelected = NO;
    filterBtn.isSelected = NO;
}

@end
