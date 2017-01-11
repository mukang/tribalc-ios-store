//
//  TCRestaurantSortView.h
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSelectSortButton.h"

@interface TCRestaurantSortView : UIView

@property  (retain, nonatomic) TCSelectSortButton *averageMinBtn;

@property (retain, nonatomic) TCSelectSortButton *averageMaxBtn;

@property (retain, nonatomic) TCSelectSortButton *popularityMaxBtn;

@property (retain, nonatomic) TCSelectSortButton *distanceMinBtn;

@property (retain, nonatomic) TCSelectSortButton *evaluateMaxBtn;

@end
