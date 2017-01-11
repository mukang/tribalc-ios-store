//
//  TCGetNavigationItem.m
//  individual
//
//  Created by WYH on 16/11/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGetNavigationItem.h"

@implementation TCGetNavigationItem


+ (UIBarButtonItem *)getBarItemWithFrame:(CGRect)frame AndImageName:(NSString *)imgName {
    
    UIButton *button = [self getBarButtonWithFrame:frame AndImageName:imgName];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barItem;
}

+ (UILabel *)getTitleItemWithText:(NSString *)text {
    UILabel *centerLab = [[UILabel alloc] init];
    centerLab.text = text;
    [centerLab sizeToFit];
    centerLab.textColor = [UIColor whiteColor];
    centerLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(16)];
    return centerLab;
}

+ (UIButton *)getBarButtonWithFrame:(CGRect)frame AndImageName:(NSString *)imageName {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:imageName];
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    backImgView.image = img;
    [backBtn addSubview:backImgView];
    return backBtn;
}


@end
