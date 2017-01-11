//
//  TCSelectButton.m
//  individual
//
//  Created by WYH on 16/12/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectButton.h"

@implementation TCSelectButton


- (void)setupNoSelectedStyle {
    
}

- (void)setupSelectedStyle {
    
}

- (void)setupInvalidStyle {
    
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self setupSelectedStyle];
    } else {
        [self setupNoSelectedStyle];
    }
}

- (void)setIsEffective:(BOOL)isEffective {
    _isEffective = isEffective;
    if (isEffective) {
        [self setupInvalidStyle];
    }
}

@end
