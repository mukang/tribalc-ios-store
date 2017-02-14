//
//  TCGoodsCategoryController.m
//  store
//
//  Created by 王帅锋 on 17/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsCategoryController.h"
#import "TCStoreCategoryIconViewCell.h"
#import "TCStoreCategoryInfo.h"
#import "NSObject+TCModel.h"
#import "TCCreateGoodsViewController.h"
#import "TCChoseSpecificationsController.h"

@interface TCGoodsCategoryController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSArray *goodsCategoryInfoArray;

@end

@implementation TCGoodsCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择类目";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
//    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = TCRGBColor(212, 212, 212);
//    [self.view addSubview:topView];
//    
//    UIImageView *titleImageView = [[UIImageView alloc] init];
//    [self.view addSubview:titleImageView];
////    self.titleImageView = titleImageView;
//    
//    UILabel *titleLabel = [[UILabel alloc] init];
////    titleLabel.textColor = TCRGBColor(252, 108, 38);
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.text = @"选择类目";
//    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
//    [self.view addSubview:titleLabel];
//    
//    UIView *separatorView = [[UIView alloc] init];
//    separatorView.backgroundColor = TCRGBColor(212, 212, 212);
//    [self.view addSubview:separatorView];
//    self.separatorView = separatorView;
    
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
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self.view);
//        make.height.equalTo(@(TCRealValue(9)));
//    }];
//    
//    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(TCRealValue(13), TCRealValue(13)));
//        make.centerX.equalTo(self.view).with.offset(-(TCRealValue(16)));
//        make.top.equalTo(topView.mas_bottom).offset(TCRealValue(16));
//    }];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(TCRealValue(100), TCRealValue(16)));
//        make.left.equalTo(titleImageView.mas_right).with.offset(3);
//        make.centerY.equalTo(titleImageView.mas_centerY);
//    }];
//    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(TCRealValue(54));
//        make.left.equalTo(self.view).with.offset(20);
//        make.right.equalTo(self.view).with.offset(-20);
//        make.height.mas_equalTo(0.5);
//    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(separatorView.mas_bottom);
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(TCRealValue(220)));
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsCategoryInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreCategoryIconViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCStoreCategoryIconViewCell" forIndexPath:indexPath];
    TCStoreCategoryInfo *categoryInfo = self.goodsCategoryInfoArray[indexPath.item];
    cell.categoryInfo = categoryInfo;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item != 7) {
        TCStoreCategoryInfo *storeInfo = _goodsCategoryInfoArray[indexPath.item];
        NSString *category = storeInfo.category;
        TCGoodsMeta *good = [[TCGoodsMeta alloc] init];
        good.category = category;
        TCChoseSpecificationsController *createVC = [[TCChoseSpecificationsController alloc] init];
        createVC.good = good;
        [self.navigationController pushViewController:createVC animated:YES];
    }else {
        [MBProgressHUD showHUDWithMessage:@"此功能暂未开放，敬请期待！"];
    }
    
    
//    if ([self.delegate respondsToSelector:@selector(storeCategoryViewCell:didSelectItemWithCategoryInfo:)]) {
//        TCStoreCategoryInfo *categoryInfo = self.categoryInfoArray[indexPath.item];
//        [self.delegate storeCategoryViewCell:self didSelectItemWithCategoryInfo:categoryInfo];
//    }
}

- (NSArray *)goodsCategoryInfoArray {
    if (_goodsCategoryInfoArray == nil) {
        NSArray *array = @[
                           @{@"name": @"美食", @"icon": @"category_food", @"category": @"FOOD"},
                           @{@"name": @"礼品", @"icon": @"category_gift", @"category": @"GIFT"},
                           @{@"name": @"办公用品", @"icon": @"category_office", @"category": @"OFFICE"},
                           @{@"name": @"生活用品", @"icon": @"category_living", @"category": @"LIVING"},
                           @{@"name": @"家具用品", @"icon": @"category_house", @"category": @"HOUSE"},
                           @{@"name": @"个护化妆", @"icon": @"category_makeup", @"category": @"MAKEUP"},
                           @{@"name": @"妇婴用品", @"icon": @"category_penetration", @"category": @"PENETRATION"},
                           @{@"name": @"会员卡", @"icon": @"category_penetration", @"category": @"PENETRATION"}
                           ];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreCategoryInfo *categoryInfo = [[TCStoreCategoryInfo alloc] initWithObjectDictionary:dic];
            [temp addObject:categoryInfo];
        }
        _goodsCategoryInfoArray = [NSArray arrayWithArray:temp];
    }
    return _goodsCategoryInfoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
