//
//  TCCookingStyleViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCookingStyleViewCell.h"
#import "TCStoreFeatureViewCell.h"
#import "TCStoreFeature.h"

@interface TCCookingStyleViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation TCCookingStyleViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"菜系类型";
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCRGBColor(212, 212, 212);
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf(TCRealValue(65)), floorf(TCRealValue(24)));
    layout.minimumLineSpacing = floorf(TCRealValue(10));
    layout.minimumInteritemSpacing = floorf(TCRealValue(20));
    layout.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(20)), floorf(TCRealValue(27.5)), floorf(TCRealValue(30)), floorf(TCRealValue(27.5)));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCStoreFeatureViewCell class] forCellWithReuseIdentifier:@"TCStoreFeatureViewCell"];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(TCRealValue(42));
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.separatorView.mas_bottom);
        make.left.bottom.right.equalTo(weakSelf.contentView);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.features.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreFeatureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCStoreFeatureViewCell" forIndexPath:indexPath];
    TCStoreFeature *feature = self.features[indexPath.item];
    cell.feature = feature;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(cookingStyleViewCell:didSelectItemAtIndex:)]) {
        [self.delegate cookingStyleViewCell:self didSelectItemAtIndex:indexPath.item];
    }
}

- (void)setFeatures:(NSArray *)features {
    _features = features;
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
