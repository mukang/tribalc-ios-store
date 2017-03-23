//
//  TCServiceListViewController.m
//  store
//
//  Created by 穆康 on 2017/2/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceListViewController.h"
#import "TCServiceDetailViewController.h"
#import "TCServiceMapViewController.h"

#import "TCServiceTabBar.h"
#import "TCServiceListCell.h"

#import "TCRefreshHeader.h"
#import "TCRefreshFooter.h"

#import "TCBuluoApi.h"

#import <MAMapKit/MAMapKit.h>

@interface TCServiceListViewController () <UITableViewDataSource, UITableViewDelegate, TCServiceTabBarDelegate>

@property (weak, nonatomic) TCServiceTabBar *serviceTabBar;
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic) NSInteger limitSize;
@property (copy, nonatomic) NSString *sortSkip;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (copy, nonatomic) NSArray *coordinateArray;

@end

@implementation TCServiceListViewController {
    __weak TCServiceListViewController *weakSelf;
}

- (instancetype)initWithServiceType:(TCServiceType)serviceType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _serviceType = serviceType;
        _limitSize = 20;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadNewData];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    if (self.serviceType == TCServiceTypeRepast) {
        self.navigationItem.title = @"餐饮";
    } else {
        self.navigationItem.title = @"娱乐";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"service_location"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickLocationButton:)];
}

- (void)setupSubviews {
    TCServiceTabBar *serviceTabBar = [[TCServiceTabBar alloc] initWithController:self];
    serviceTabBar.delegate = self;
    self.serviceTabBar = serviceTabBar;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = TCRealValue(160);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCServiceListCell class] forCellReuseIdentifier:@"TCServiceListCell"];
    tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.view insertSubview:tableView atIndex:0];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(42);
        make.leading.bottom.trailing.equalTo(weakSelf.view);
    }];
}

- (void)loadNewData {
    [MBProgressHUD showHUD:YES];
    NSString *query = [self composeQueryWithSortSkip:nil
                                            sortType:self.serviceTabBar.sortView.sortType
                                          filterType:self.serviceTabBar.filterView.filterType];
    [[TCBuluoApi api] fetchServiceWrapperWithQuery:query result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (serviceWrapper) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.sortSkip = serviceWrapper.nextSkip;
            [weakSelf.dataList removeAllObjects];
            [weakSelf addDistanceInServiceArray:serviceWrapper.content];
            [weakSelf.dataList addObjectsFromArray:serviceWrapper.content];
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    NSString *query = [self composeQueryWithSortSkip:self.sortSkip
                                            sortType:self.serviceTabBar.sortView.sortType
                                          filterType:self.serviceTabBar.filterView.filterType];
    [[TCBuluoApi api] fetchServiceWrapperWithQuery:query result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
        if (serviceWrapper) {
            if (serviceWrapper.hasMore) {
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            weakSelf.sortSkip = serviceWrapper.nextSkip;
            [weakSelf addDistanceInServiceArray:serviceWrapper.content];
            [weakSelf.dataList addObjectsFromArray:serviceWrapper.content];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (NSString *)composeQueryWithSortSkip:(NSString *)sortSkip sortType:(TCServiceSortType)sortType filterType:(TCServiceFilterType)filterType {
    NSString *category = (self.serviceType == TCServiceTypeRepast) ? @"REPAST" : @"HAIRDRESSING,FITNESS,ENTERTAINMENT,KEEPHEALTHY";
    NSString *categoryPart = [NSString stringWithFormat:@"category=%@", category];
    NSString *limitSizePart = [NSString stringWithFormat:@"&limitSize=%zd", self.limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *coordinatePart = @"";
    NSString *sortPart = @"";
    switch (sortType) {
        case TCServiceSortTypePerCapitaAsc:
            sortPart = @"&sort=personExpense,asc";
            break;
        case TCServiceSortTypePerCapitaDesc:
            sortPart = @"&sort=personExpense,desc";
            break;
        case TCServiceSortTypePopularityDesc:
            sortPart = @"&sort=popularValue,desc";
            break;
        case TCServiceSortTypeLocationAsc:
            if ([self.coordinateArray isKindOfClass:[NSArray class]] && self.coordinateArray.count == 2) {
                coordinatePart = [NSString stringWithFormat:@"&coordinate=%@,%@&", self.coordinateArray[1], self.coordinateArray[0]];
            }
            break;
        case TCServiceSortTypeEvaluationDesc:
            
            break;
            
        default:
            break;
    }
    switch (filterType) {
        case TCServiceFilterTypeReservation:
            
            break;
        case TCServiceFilterTypeHome:
            
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@%@%@%@", categoryPart, limitSizePart, sortSkipPart, coordinatePart, sortPart];
}

- (void)addDistanceInServiceArray:(NSArray *)serviceArray {
    if ([self.coordinateArray isKindOfClass:[NSArray class]] && self.coordinateArray.count == 2) {
        CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([self.coordinateArray[0] doubleValue], [self.coordinateArray[1] doubleValue]);
        MAMapPoint point1 = MAMapPointForCoordinate(userCoordinate);
        for (TCService *service in serviceArray) {
            if (service.store.coordinate) {
                MAMapPoint point2 = MAMapPointForCoordinate(service.store.coordinate2D);
                service.store.distance = MAMetersBetweenMapPoints(point1,point2) / 1000;
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCServiceListCell" forIndexPath:indexPath];
    TCService *service = self.dataList[indexPath.row];
    cell.isRes = (self.serviceType == TCServiceTypeRepast) ? YES : NO;
    cell.service = service;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCService *service = self.dataList[indexPath.row];
    TCServiceDetailViewController *vc = [[TCServiceDetailViewController alloc] init];
    vc.serviceID = service.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCServiceTabBarDelegate

- (void)serviceTabBar:(TCServiceTabBar *)tabBar didSelectItemViewWithSortType:(TCServiceSortType)sortType filterType:(TCServiceFilterType)filterType {
    [self loadNewData];
}

#pragma mark - Actions

- (void)handleClickLocationButton:(UIBarButtonItem *)sender {
    TCServiceMapViewController *vc = [[TCServiceMapViewController alloc] init];
    vc.navigationItem.title = self.navigationItem.title;
    vc.dataList = self.dataList;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSArray *)coordinateArray {
    if (_coordinateArray == nil) {
        _coordinateArray = [[NSUserDefaults standardUserDefaults] objectForKey:TCBuluoUserLocationCoordinateKey];
    }
    return _coordinateArray;
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
