//
//  TCServiceSelectBtn.m
//  individual
//
//  Created by WYH on 16/12/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceSelectBtn.h"

@implementation TCServiceSelectBtn {
    UILabel *titleLab;
    UIImageView *imageView;
}


- (instancetype)initWithFrame:(CGRect)frame AndText:(NSString *)text AndImgName:(NSString *)imgName{
    self = [super initWithFrame:frame];
    if (self) {
        titleLab = [[UILabel alloc] init];
        titleLab.text = text;
        titleLab.font = [UIFont fontWithName:@"Arial" size:TCRealValue(14)];
        titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
        [titleLab sizeToFit];
        
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        NSLog(@"%f %f", [UIImage imageNamed:imgName].size.width, [UIImage imageNamed:imgName].size.height);
        [imageView sizeToFit];
        
        [titleLab setOrigin:CGPointMake(frame.size.width / 2 - (titleLab.size.width + imageView.size.width) / 2, (frame.size.height - titleLab.height) / 2)];
        [imageView setOrigin:CGPointMake(titleLab.x + titleLab.width + TCRealValue(3), (frame.size.height - imageView.height) / 2)];
        
        [self addSubview:titleLab];
        [self addSubview:imageView];
        
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        titleLab.textColor = TCRGBColor(81, 199, 209);
        imageView.image = [UIImage imageNamed:@"res_select_blue"];
    } else {
        titleLab.textColor = TCRGBColor(42, 42, 42);
        imageView.image = [UIImage imageNamed:@"res_select_down"];
    }
}


@end
