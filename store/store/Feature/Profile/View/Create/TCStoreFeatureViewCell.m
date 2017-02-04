//
//  TCStoreFeatureViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreFeatureViewCell.h"
#import "TCStoreFeature.h"

@interface TCStoreFeatureViewCell ()

@property (weak, nonatomic) UIView *bgView;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCStoreFeatureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 2.5;
    bgView.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    bgView.layer.borderWidth = 1;
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}

- (void)setFeature:(TCStoreFeature *)feature {
    self.titleLabel.text = feature.name;
    if (feature.selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.bgView.backgroundColor = TCRGBColor(252, 108, 38);
        self.bgView.layer.borderColor = TCRGBColor(252, 108, 38).CGColor;
    } else {
        self.titleLabel.textColor = TCRGBColor(42, 42, 42);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    }
}

+ (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath withFeature:(TCStoreFeature *)feature {
    CGFloat minWidth = TCRealValue(65);
    CGFloat width = [feature.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 21)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{
                                                         NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12)]
                                                         }
                                               context:nil].size.width;
    if (width < minWidth) {
        width = minWidth;
    }
    return CGSizeMake(floorf(width), floorf(TCRealValue(24)));
}

@end
