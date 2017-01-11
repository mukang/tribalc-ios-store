//
//  TCSelectPrimaryBtn.m
//  individual
//
//  Created by WYH on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectPrimaryBtn.h"

@implementation TCSelectPrimaryBtn


- (instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.layer.cornerRadius = TCRealValue(5);
        self.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
        self.layer.borderWidth = TCRealValue(1);
        [self setupNoSelectedStyle];
        [self sizeToFit];
        [self setHeight:TCRealValue(49 / 2)];
        [self setWidth:self.width + TCRealValue(22)];
        self.isEffective = YES;
    }
    
    return self;
}

- (void)setupNoSelectedStyle {
    self.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
    [self setTitleColor:TCRGBColor(154, 154, 154) forState:UIControlStateNormal];
}

- (void)setupSelectedStyle {
    self.layer.borderColor = TCRGBColor(81, 199, 209).CGColor;
    [self setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
}

- (void)setupInvalidStyle {
    self.layer.borderColor = TCRGBColor(242, 242, 242).CGColor;
    [self setTitleColor:TCRGBColor(242, 242, 242) forState:UIControlStateNormal];
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
