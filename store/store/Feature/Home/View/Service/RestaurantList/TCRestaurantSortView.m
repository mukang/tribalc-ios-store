//
//  TCRestaurantSortView.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantSortView.h"

@implementation TCRestaurantSortView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(0.5))];
        topLine.backgroundColor = TCRGBColor(242, 242, 242);
        [self addSubview:topLine];
        
        UIView *firstVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(TCRealValue(24) + TCRealValue(105), (frame.size.height - TCRealValue(169)) / 2, TCRealValue(0.5), TCRealValue(169))];
        firstVerticalLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        UIView *secondVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - TCRealValue(24) - TCRealValue(119) + TCRealValue(13), firstVerticalLine.y, firstVerticalLine.width, firstVerticalLine.height)];
        secondVerticalLine.backgroundColor = firstVerticalLine.backgroundColor;
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(TCRealValue(24), frame.size.height / 2 - 0.5, frame.size.width - TCRealValue(48), TCRealValue(0.5))];
        horizontalLine.backgroundColor = secondVerticalLine.backgroundColor;
        [self addSubview:firstVerticalLine];
        [self addSubview:secondVerticalLine];
        [self addSubview:horizontalLine];
        
        
        
        _averageMinBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(TCRealValue(24), 0, firstVerticalLine.x - TCRealValue(24), horizontalLine.y) AndImgName:@"res_average_min" AndText:@"人均最低"];
        [self addSubview:_averageMinBtn];

        _averageMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(firstVerticalLine.x + firstVerticalLine.width, 0, secondVerticalLine.x - firstVerticalLine.x + firstVerticalLine.width, _averageMinBtn.height) AndImgName:@"res_average_max" AndText:@"人均最高"];
        [self addSubview:_averageMaxBtn];
        
        _popularityMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(secondVerticalLine.x + TCRealValue(0.5), 0, frame.size.width - TCRealValue(24) - secondVerticalLine.x + TCRealValue(1), _averageMinBtn.height) AndImgName:@"res_popularity_max" AndText:@"人气最高"];
        [self addSubview:_popularityMaxBtn];
        
        _distanceMinBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(_averageMinBtn.x, frame.size.height / 2, _averageMinBtn.width, frame.size.height - _averageMinBtn.height + TCRealValue(0.5)) AndImgName:@"res_near" AndText:@"离我最近"];
        [self addSubview:_distanceMinBtn];
        
        _evaluateMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(_averageMaxBtn.x, _distanceMinBtn.y, _averageMaxBtn.width, _distanceMinBtn.height) AndImgName:@"res_evaluate" AndText:@"评价最高"];
        [self addSubview:_evaluateMaxBtn];
        
                
    }
    
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
