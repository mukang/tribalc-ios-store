//
//  TCGoodSelectTitleView.h
//  individual
//
//  Created by WYH on 16/12/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface TCGoodSelectTitleView : UIView <SDWebImageManagerDelegate>

@property (nonatomic) UIImageView *selectImageView;

@property (nonatomic) UILabel *selectPriceLab;

@property (nonatomic) UILabel *selectRepertoryLab;

@property (nonatomic) UILabel *selectPrimaryLab;

@property (nonatomic) UILabel *selectSecondaryLab;

- (void)setupRepertory:(NSInteger)repertory;

- (void)setupSecondary:(NSString *)secondary;

- (void)setupPrimary:(NSString *)primary;

- (NSInteger)getRepertory;

@end
