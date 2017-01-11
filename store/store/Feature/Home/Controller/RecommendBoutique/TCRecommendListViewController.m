//
//  TCRecommendListViewController.m
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendListViewController.h"
#import "UIImage+Category.h"

@interface TCRecommendListViewController () {
    TCGoodsWrapper *goodsInfoWrapper;
    UICollectionView *recommendCollectionView;
    UIImageView *collectionImageView;
    NSMutableArray *collectionImgArr;
}

@end

@implementation TCRecommendListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor = TCRGBColor(42, 42, 42);
    barImageView.alpha = 1;
    [self setupNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    collectionImgArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCollectionView];

    [self loadGoodsData];

}


# pragma mark - Navigation Bar
- (void)setupNavigationBar {
    
    self.navigationItem.title = @"精品推荐";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchBackBtn:)];
}


# pragma mark - GetData
- (void)loadGoodsData {
    [MBProgressHUD showHUD:YES];
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodsWrapper:20 sortSkip:nil result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        if (goodsWrapper) {
            [MBProgressHUD hideHUD:YES];
            goodsInfoWrapper = goodsWrapper;
            [recommendCollectionView reloadData];
            [recommendCollectionView.mj_header endRefreshing];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取商品列表失败, %@", reason]];
        }
    }];
}

- (void)loadGoodsDataWithSortSkip:(NSString *)sortSkip {
    if (goodsInfoWrapper.hasMore == YES) {
        TCBuluoApi *api = [TCBuluoApi api];
        [api fetchGoodsWrapper:20 sortSkip:sortSkip result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
            if (goodsWrapper) {
                NSArray *infoArr = goodsInfoWrapper.content;
                goodsInfoWrapper = goodsWrapper;
                goodsInfoWrapper.content = [infoArr arrayByAddingObjectsFromArray:goodsWrapper.content];
                [recommendCollectionView reloadData];
                [recommendCollectionView.mj_footer endRefreshing];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取商品列表失败, %@", reason]];
            }
        }];
    } else {
        TCRecommendFooter *footer = (TCRecommendFooter *)recommendCollectionView.mj_footer;
        [footer setTitle:@"已加载全部" forState:MJRefreshStateRefreshing];
        [recommendCollectionView.mj_footer endRefreshing];
    }
}

#pragma mark - UI

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(TCRealValue(338 / 2), TCRealValue(428 / 2 + 158 / 2));
    layout.sectionInset = UIEdgeInsetsMake(TCRealValue(7), TCRealValue(12.5), TCRealValue(7), TCRealValue(12));
    layout.minimumLineSpacing = TCRealValue(8);
    recommendCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    recommendCollectionView.delegate = self;
    recommendCollectionView.dataSource = self;
    recommendCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    recommendCollectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:recommendCollectionView];
    [recommendCollectionView registerClass:[TCRecommendGoodCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self setupCollectionPullToRefresh];
}

- (void)setupCollectionPullToRefresh {
    
    TCRecommendHeader *refreshHeader = [TCRecommendHeader headerWithRefreshingBlock:^{
        [self loadGoodsData];
    }];
    recommendCollectionView.mj_header = refreshHeader;
    
    TCRecommendFooter *refreshFooter = [TCRecommendFooter footerWithRefreshingBlock:^{
        [self loadGoodsDataWithSortSkip:goodsInfoWrapper.nextSkip];
    }];
    recommendCollectionView.mj_footer = refreshFooter;
}


# pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsInfoWrapper.content.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoods *info = goodsInfoWrapper.content[indexPath.row];
    TCRecommendGoodCell *cell = (TCRecommendGoodCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:info.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(169), TCRealValue(214))];
    [cell.goodImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    cell.shopNameLab.text = info.brand;
    cell.typeAndNameLab.text = [NSString stringWithFormat:@"%@", info.name];
    NSString *salePriceStr = [NSString stringWithFormat:@"%f", info.salePrice];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", @(salePriceStr.floatValue)];
    collectionImgArr[indexPath.row] = cell.collectionImgView;
    [cell.collectionBtn addTarget:self action:@selector(touchCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.collectionBtn.tag = indexPath.row;
    
    return cell;
}


#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoods *goodInfo = goodsInfoWrapper.content[indexPath.row];
    TCRecommendInfoViewController *recommendInfoViewController = [[TCRecommendInfoViewController alloc] initWithGoodId:goodInfo.ID];
    [self.navigationController pushViewController:recommendInfoViewController animated:YES];
}


# pragma mark - Touch Action
- (void)touchCollectionButton:(UIButton *)button {
    NSInteger index = button.tag;
    
    UIImageView *imgView = collectionImgArr[index];
    UIImage *image = [UIImage imageNamed:@"good_collection_no"];
    UIImage *selectImg = [UIImage imageNamed:@"good_collection_yes"];
    if ([imgView.image isEqual:image]) {
        imgView.image = selectImg;
    } else {
        imgView.image = image;
    }

}

- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
