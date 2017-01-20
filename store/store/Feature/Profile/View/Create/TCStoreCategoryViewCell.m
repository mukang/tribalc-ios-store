//
//  TCStoreCategoryViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreCategoryViewCell.h"
#import "TCStoreCategoryInfo.h"
#import "TCStoreCategoryIconViewCell.h"

@interface TCStoreCategoryViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation TCStoreCategoryViewCell

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
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:titleImageView];
    self.titleImageView = titleImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCRGBColor(252, 108, 38);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCRGBColor(212, 212, 212);
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf(TCRealValue(72)), floorf(TCRealValue(72)));
    layout.minimumLineSpacing = floorf(TCRealValue(12));
    layout.minimumInteritemSpacing = floorf(TCRealValue(12));
    layout.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(19)), floorf(TCRealValue(24)), 0, floorf(TCRealValue(24)));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCStoreCategoryIconViewCell class] forCellWithReuseIdentifier:@"TCStoreCategoryIconViewCell"];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.centerX.equalTo(weakSelf.contentView.mas_centerX).with.offset(-16);
        make.centerY.equalTo(weakSelf.separatorView.mas_centerY).with.offset(-14);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 16));
        make.left.equalTo(weakSelf.titleImageView.mas_right).with.offset(3);
        make.centerY.equalTo(weakSelf.titleImageView.mas_centerY);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(TCRealValue(45));
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
    return self.categoryInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreCategoryIconViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCStoreCategoryIconViewCell" forIndexPath:indexPath];
    TCStoreCategoryInfo *categoryInfo = self.categoryInfoArray[indexPath.item];
    cell.categoryInfo = categoryInfo;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(storeCategoryViewCell:didSelectItemWithCategoryInfo:)]) {
        TCStoreCategoryInfo *categoryInfo = self.categoryInfoArray[indexPath.item];
        [self.delegate storeCategoryViewCell:self didSelectItemWithCategoryInfo:categoryInfo];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
