//
//  TCStoreFacilitiesViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreFacilitiesViewCell.h"
#import "TCCreateStorePromptView.h"
#import "TCStoreFeatureViewCell.h"
#import "TCStoreFeature.h"

@interface TCStoreFacilitiesViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) TCCreateStorePromptView *promptView;

@end

@implementation TCStoreFacilitiesViewCell

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
    titleLabel.text = @"辅助设施";
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"（可多选）";
    subtitleLabel.textColor = TCRGBColor(154, 154, 154);
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCRGBColor(212, 212, 212);
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.estimatedItemSize = CGSizeMake(floorf(TCRealValue(65)), floorf(TCRealValue(24)));
    layout.minimumLineSpacing = floorf(TCRealValue(10));
    layout.minimumInteritemSpacing = floorf(TCRealValue(20));
    layout.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(20)), floorf(TCRealValue(27.5)), floorf(TCRealValue(10)), floorf(TCRealValue(27.5)));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCStoreFeatureViewCell class] forCellWithReuseIdentifier:@"TCStoreFeatureViewCell"];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    TCCreateStorePromptView *promptView = [[TCCreateStorePromptView alloc] init];
    [self.contentView addSubview:promptView];
    self.promptView = promptView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(weakSelf.contentView.mas_top).with.offset(TCRealValue(21));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right);
        make.bottom.equalTo(weakSelf.titleLabel.mas_bottom);
        make.height.mas_equalTo(14);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(TCRealValue(42));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.separatorView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-40);
    }];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
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
    if ([self.delegate respondsToSelector:@selector(storeFacilitiesViewCell:didSelectItemAtIndex:)]) {
        [self.delegate storeFacilitiesViewCell:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreFeature *feature = self.features[indexPath.item];
    CGSize size = [TCStoreFeatureViewCell collectionView:collectionView sizeForItemAtIndexPath:indexPath withFeature:feature];
    TCLog(@"--->%@", NSStringFromCGSize(size));
    return size;
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
