//
//  TCSelectSecondaryBtn.m
//  individual
//
//  Created by WYH on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectSecondaryBtn.h"

@implementation TCSelectSecondaryBtn

- (instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
        self.layer.cornerRadius = TCRealValue(11);
        [self setupNoSelectedStyle];
        [self sizeToFit];
        [self setHeight:TCRealValue(22)];
        [self setWidth:self.width + TCRealValue(25)];
        self.isEffective = YES;
    }
    
    return self;
}

- (void)setupNoSelectedStyle {
    [self setTitleColor:TCBlackColor forState:UIControlStateNormal];
    self.backgroundColor = TCBackgroundColor;
}

- (void)setupSelectedStyle {
    [self setTitleColor:TCRGBColor(255, 255, 255) forState:UIControlStateNormal];
    self.backgroundColor = TCRGBColor(81, 199, 209);
}

- (void)setupInvalidStyle {
    [self setTitleColor:TCRGBColor(205, 205, 205) forState:UIControlStateNormal];
    self.backgroundColor = TCBackgroundColor;
}

- (void)setIsSelected:(BOOL)isSelected {
    [super setIsSelected:isSelected];
    if (isSelected) {
        [self setupSelectedStyle];
    } else {
        [self setupNoSelectedStyle];
    }
}

- (void)setIsEffective:(BOOL)isEffective {
    [super setIsEffective:isEffective];
    if (!isEffective) {
        [self setupInvalidStyle];
    } else {
        if (self.isSelected) {
            [self setupSelectedStyle];
        } else {
            [self setupNoSelectedStyle];
        }
    }

}


@end
