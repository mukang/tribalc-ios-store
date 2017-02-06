//
//  TCStoreFeatureViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCStoreFeature;

@interface TCStoreFeatureViewCell : UICollectionViewCell

@property (strong, nonatomic) TCStoreFeature *feature;

+ (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath withFeature:(TCStoreFeature *)feature;

@end
