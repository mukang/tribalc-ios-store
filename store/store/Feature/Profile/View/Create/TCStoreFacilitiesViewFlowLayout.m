//
//  TCStoreFacilitiesViewFlowLayout.m
//  store
//
//  Created by 穆康 on 2017/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreFacilitiesViewFlowLayout.h"

@implementation TCStoreFacilitiesViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.minimumLineSpacing = floorf(TCRealValue(10));
    self.minimumInteritemSpacing = floorf(TCRealValue(20));
    self.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(20)), floorf(TCRealValue(27.5)), floorf(TCRealValue(10)), floorf(TCRealValue(27.5)));
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (int i=1; i<array.count; i++) {
        UICollectionViewLayoutAttributes *currentAttr = array[i];
        UICollectionViewLayoutAttributes *previousAttr = array[i-1];
        
        CGFloat preMaxX = CGRectGetMaxX(previousAttr.frame);
        
        if (preMaxX + self.minimumInteritemSpacing + currentAttr.size.width + self.sectionInset.left + self.sectionInset.right < self.collectionViewContentSize.width) {
            CGRect temp = currentAttr.frame;
            temp.origin.x = preMaxX + self.minimumInteritemSpacing;
            currentAttr.frame = temp;
        }
    }
    return array;
}

@end
