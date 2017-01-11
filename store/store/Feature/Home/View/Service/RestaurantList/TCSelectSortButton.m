//
//  TCSelectSortButton.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectSortButton.h"

@implementation TCSelectSortButton {
    NSString *imageName;
    UIButton *imgBtn;
    UILabel *textLab;
}

- (instancetype)initWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndText:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        imageName = imgName;
        
        imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, TCRealValue(24), frame.size.width, 0)];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgBtn setHeight:30];
        imgBtn.userInteractionEnabled = NO;
        [imgBtn setImage:img forState:UIControlStateNormal];
        
        textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgBtn.y + imgBtn.height + TCRealValue(11), self.width, TCRealValue(12))];
        textLab.text = text;
        textLab.font = [UIFont systemFontOfSize:TCRealValue(14)];
        textLab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:imgBtn];
        [self addSubview:textLab];
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_high", imageName]];
        [imgBtn setImage:img forState:UIControlStateNormal];
        textLab.textColor = [UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    } else {
        [imgBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        textLab.textColor = [UIColor blackColor];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
