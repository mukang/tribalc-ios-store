//
//  TCGoodsOrderViewController.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderViewController.h"
#import "TCGoodsOrderDetailViewController.h"

#import "TCGoodsOrderViewCell.h"
#import "TCGoodsOrderHeaderView.h"
#import "TCGoodsOrderFooterView.h"

#import <TCCommonLibs/TCTabView.h>
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>

#import "TCBuluoApi.h"

@interface TCGoodsOrderViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString *currentStatus;
@property (nonatomic) NSInteger limitSize;
@property (copy, nonatomic) NSString *sortSkip;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation TCGoodsOrderViewController {
    __weak TCGoodsOrderViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"订单管理";
    self.limitSize = 20;
    self.currentStatus = nil;
    
    [self setupSubviews];
    [self loadNewData];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCTabView *tabView = [[TCTabView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 40) titleArr:@[@"全部", @"待付款", @"待发货", @"待收货", @"已完成"]];
    tabView.tapBlock = ^(NSInteger index) {
        switch (index) {
            case 0:
                weakSelf.currentStatus = nil;
                break;
            case 1:
                weakSelf.currentStatus = @"NO_SETTLE";
                break;
            case 2:
                weakSelf.currentStatus = @"SETTLE";
                break;
            case 3:
                weakSelf.currentStatus = @"DELIVERY";
                break;
            case 4:
                weakSelf.currentStatus = @"RECEIVED";
                break;
                
            default:
                weakSelf.currentStatus = nil;
                break;
        }
        [weakSelf loadNewData];
    };
    [self.view addSubview:tabView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(TCScreenWidth, 118);
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(TCScreenWidth, 49);
    layout.footerReferenceSize = CGSizeMake(TCScreenWidth, 9);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = TCBackgroundColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCGoodsOrderViewCell class] forCellWithReuseIdentifier:@"TCGoodsOrderViewCell"];
    [collectionView registerClass:[TCGoodsOrderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TCGoodsOrderHeaderView"];
    [collectionView registerClass:[TCGoodsOrderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TCGoodsOrderFooterView"];
    collectionView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    collectionView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(40);
        make.left.bottom.right.equalTo(weakSelf.view);
    }];
}

- (void)loadNewData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchGoodsOrderWrapper:self.currentStatus limitSize:self.limitSize sortSkip:nil result:^(TCGoodsOrderWrapper *goodsOrderWrapper, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (goodsOrderWrapper) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.sortSkip = goodsOrderWrapper.nextSkip;
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:goodsOrderWrapper.content];
            [weakSelf.collectionView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取订单数据失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchGoodsOrderWrapper:self.currentStatus limitSize:self.limitSize sortSkip:self.sortSkip result:^(TCGoodsOrderWrapper *goodsOrderWrapper, NSError *error) {
        if (goodsOrderWrapper) {
            [MBProgressHUD hideHUD:YES];
            if (goodsOrderWrapper.hasMore) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            weakSelf.sortSkip = goodsOrderWrapper.nextSkip;
            [weakSelf.dataList addObjectsFromArray:goodsOrderWrapper.content];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取订单数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TCGoodsOrder *goodsOrder = self.dataList[section];
    return goodsOrder.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCGoodsOrderViewCell" forIndexPath:indexPath];
    TCGoodsOrder *goodsOrder = self.dataList[indexPath.section];
    TCGoodsOrderItem *orderItem = goodsOrder.itemList[indexPath.row];
    cell.orderItem = orderItem;
    cell.account = goodsOrder.user;
    cell.purchaser = goodsOrder.nickName;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TCGoodsOrderHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TCGoodsOrderHeaderView" forIndexPath:indexPath];
        TCGoodsOrder *goodsOrder = self.dataList[indexPath.section];
        view.order = goodsOrder;
        return view;
    } else {
        TCGoodsOrderFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TCGoodsOrderFooterView" forIndexPath:indexPath];
        return view;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsOrder *goodsOrder = self.dataList[indexPath.section];
    TCGoodsOrderDetailViewController *vc = [[TCGoodsOrderDetailViewController alloc] init];
    vc.goodsOrder = goodsOrder;
    vc.statusChangeBlock = ^(TCGoodsOrder *goodsOrder) {
        if (weakSelf.currentStatus == nil) {
            for (int i=0; i<weakSelf.dataList.count; i++) {
                TCGoodsOrder *order = weakSelf.dataList[i];
                if ([order.ID isEqualToString:goodsOrder.ID]) {
                    [weakSelf.dataList replaceObjectAtIndex:i withObject:goodsOrder];
                    break;
                }
            }
            [weakSelf.collectionView reloadData];
        } else if ([weakSelf.currentStatus isEqualToString:@"SETTLE"]) {
            for (int i=0; i<weakSelf.dataList.count; i++) {
                TCGoodsOrder *order = weakSelf.dataList[i];
                if ([order.ID isEqualToString:goodsOrder.ID]) {
                    [weakSelf.dataList removeObjectAtIndex:i];
                    break;
                }
            }
            [weakSelf.collectionView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
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
