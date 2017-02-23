//
//  TCRestaurantTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCService.h"
#import "UIImageView+WebCache.h"

@interface TCRestaurantTableViewCell : UITableViewCell <SDWebImageManagerDelegate>

@property (strong, nonatomic) TCService *service;

@property (weak, nonatomic) UIImageView *resImgView;
@property (weak, nonatomic) UILabel *nameLab;
@property (weak, nonatomic) UILabel *rangeLab;
@property (weak, nonatomic) UILabel *markPlcaeLab;
@property (weak, nonatomic) UILabel *typeLab;
@property (weak, nonatomic) UILabel *priceLab;
@property (weak, nonatomic) UIImageView *roomLogoView;
@property (weak, nonatomic) UIImageView *reserveLogoView;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;
//
//- (void)setLocation:(NSString *)location;
//
//- (void)setType:(NSString *)type;
//
//
//- (void)setPrice:(CGFloat)price;

//- (void)isSupportRoom:(BOOL)b;

//- (void)isSupportReserve:(BOOL)b;

@end
