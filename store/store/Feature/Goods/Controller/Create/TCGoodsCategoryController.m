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
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"goods_category_background" ofType:@"png"]];
    [self.view addSubview:bgImageView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf(TCRealValue(72)), floorf(TCRealValue(72)));
    layout.minimumLineSpacing = floorf(TCRealValue(12));
    layout.minimumInteritemSpacing = floorf(TCRealValue(12));
    layout.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(19)), floorf(TCRealValue(24)), 0, floorf(TCRealValue(24)));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCStoreCategoryIconViewCell class] forCellWithReuseIdentifier:@"TCStoreCategoryIconViewCell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        TCChoseSpecificationsController *createVC = [[TCChoseSpecificationsController alloc] initWithGoods:good];
//        createVC.good = good;
        [self.navigationController pushViewController:createVC animated:YES];
    }else {
        [MBProgressHUD showHUDWithMessage:@"此功能暂未开放，敬请期待！"];
    }
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

- (void)dealloc {
    NSLog(@"---- TCGoodsCategoryController ----");
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
