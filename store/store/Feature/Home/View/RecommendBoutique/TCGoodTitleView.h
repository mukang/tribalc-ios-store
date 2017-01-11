//
//  TCGoodTitleView.h
//  individual
//
//  Created by WYH on 16/11/25.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCGoodTitleView : UIView

@property (retain, nonatomic) UILabel *titleLab;

@property (retain, nonatomic) UILabel *priceIntegerLab;

@property (retain, nonatomic) UILabel *priceDecimalLab;

@property (retain, nonatomic) UILabel *originPriceLab;

@property (retain, nonatomic) UILabel *tagLab;

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title AndPrice:(float)price AndOriginPrice:(float)originPrice AndTags:(NSArray *)tags;

- (void)setSalePriceWithPrice:(float)price;

- (void)setTagLabWithTagArr:(NSArray *)tags;

- (void)setOriginPriceLabWithOriginPrice:(float)originPrice;

- (void)setupTitleWithText:(NSString *)text;

@end
