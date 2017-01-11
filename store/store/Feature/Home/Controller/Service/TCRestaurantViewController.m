//
//  TCRestaurantViewController.m
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantViewController.h"

@interface TCRestaurantViewController () {
    TCServiceWrapper *mServiceWrapper;
    TCServiceFilterView *filterView;
}

@end

@implementation TCRestaurantViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadRestaurantDataWithSortType:nil];
    
    [self createTableView];
}

#pragma mark - Navigation Bar
- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchBackBtn:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"res_location"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchLocationBtn:)];
}


#pragma mark - Get Data
- (void)loadRestaurantDataWithSortType:(NSString *)sortType {
    TCBuluoApi *api = [TCBuluoApi api];
    NSString *categoryStr = [self.title isEqualToString:@"餐饮"] ? @"REPAST" : @"ENTERTAINMENT";
    [MBProgressHUD showHUD:YES];
    [api fetchServiceWrapper:categoryStr limiSize:20 sortSkip:nil sort:sortType result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
        if (serviceWrapper) {
            [MBProgressHUD hideHUD:YES];
            mServiceWrapper = serviceWrapper;
            [mResaurantTableView reloadData];
            [mResaurantTableView.mj_header endRefreshing];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取%@列表失败, %@",self.title, reason]];
        }
    }];
    
}

- (void)loadResturantDataWithSortSkip:(NSString *)nextSkip AndSort:(NSString *)sortType {
    if (mServiceWrapper.hasMore == YES) {
        TCBuluoApi *api = [TCBuluoApi api];
        NSString *categoryStr = [self.title isEqualToString:@"餐饮"] ? @"REPAST" : @"ENTERTAINMENT";
        [api fetchServiceWrapper:categoryStr limiSize:20 sortSkip:nextSkip sort:sortType result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
            if (serviceWrapper) {
                NSArray *contentArr = mServiceWrapper.content;
                mServiceWrapper = serviceWrapper;
                mServiceWrapper.content = [contentArr arrayByAddingObjectsFromArray:serviceWrapper.content];
                [mResaurantTableView reloadData];
                [mResaurantTableView.mj_footer endRefreshing];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取%@列表失败, %@",self.title, reason]];
            }
        }];
    } else {
        TCRecommendFooter *footer = (TCRecommendFooter *)mResaurantTableView.mj_footer;
        [footer setTitle:@"已加载全部" forState:MJRefreshStateRefreshing];
        [mResaurantTableView.mj_footer endRefreshing];
    }
}




- (void)createTableView {
    mResaurantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height - TCRealValue(42)) style:UITableViewStyleGrouped];
    mResaurantTableView.delegate = self;
    mResaurantTableView.dataSource = self;
    [self.view addSubview:mResaurantTableView];
    
    TCRecommendHeader *refreshHeader = [TCRecommendHeader headerWithRefreshingBlock:^{
        [self loadRestaurantDataWithSortType:mServiceWrapper.sort];
    }];
    mResaurantTableView.mj_header = refreshHeader;
    
    TCRecommendFooter *refreshFooter = [TCRecommendFooter footerWithRefreshingBlock:^{
        [self loadResturantDataWithSortSkip:mServiceWrapper.nextSkip AndSort:mServiceWrapper.sort];
    }];
    mResaurantTableView.mj_footer = refreshFooter;
    
}


//- (NSString *)getDistanceWithLocation:(NSArray *)locationArr {
//    NSString *distance;
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
//    }
//    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
//        [locationManager requestWhenInUseAuthorization];
//    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
//        //设置代理
//        locationManager.delegate=self;
//        //设置定位精度
//        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        //定位频率,每隔多少米定位一次
//        CLLocationDistance distance=10.0;
//        locationManager.distanceFilter=distance;
//        //启动跟踪定位
//        [locationManager startUpdatingLocation];
//    }
//    
//    return distance;
//}





#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        filterView = [[TCServiceFilterView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(42))];
        filterView.delegate = self;
        [headerView addSubview:filterView];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mServiceWrapper.content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TCRestaurantTableViewCell *cell = [TCRestaurantTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TCServices *resInfo = mServiceWrapper.content[indexPath.row];
    cell.service = resInfo;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TCRealValue(160);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    TCServices *service = mServiceWrapper.content[indexPath.row];
    TCRestaurantInfoViewController *restaurantInfo = [[TCRestaurantInfoViewController alloc]initWithServiceId:service.ID];
    [self.navigationController pushViewController:restaurantInfo animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(42);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


#pragma mark - TCServiceFilterViewDelegate
- (void)filterView:(TCServiceFilterView *)filterView didSelectFilterServiceBtn:(NSInteger)type {
    switch (type) {
        case TCDeliver:
            [self filterByInfo:TCDeliver];
            break;
        case TCReserve:
            [self filterByInfo:TCReserve];
            break;
        default:
            break;
    }
}

- (void)filterView:(TCServiceFilterView *)filterView didSelectSortServiceBtn:(NSInteger)type {
    switch (type) {
        case TCAverageMin:
            [self sortByInfo:TCAverageMin];
            break;
        case TCAverageMax:
            [self sortByInfo:TCAverageMax];
            break;
        case TCPopularityMax:
            [self sortByInfo:TCPopularityMax];
            break;
        case TCEvaluateMax:
            [self sortByInfo:TCEvaluateMax];
            break;
        case TCDistanceMin:
            [self sortByInfo:TCDistanceMin];
            break;
        default:
            break;
    }
}


# pragma mark - Touch Action
- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchLocationBtn:(id)sender {
    TCLocationViewController *locationViewController = [[TCLocationViewController alloc] init];
    [self.navigationController pushViewController:locationViewController animated:YES];
}



# pragma mark - Sort And Filter

- (void)sortByInfo:(NSInteger)type {
    NSString *typeStr = @"";
    switch (type) {
        case TCAverageMin:
            typeStr = @"personExpense,asc";
            break;
        case TCAverageMax:
            typeStr = @"personExpense,desc";
            break;
        case TCEvaluateMax:
            
            break;
        case TCPopularityMax:
            typeStr = @"popularValue,desc";
            break;
        case TCDistanceMin:
            
            break;
        default:
            break;
    }
    
    if (![typeStr isEqualToString:@""]) {
        [self loadRestaurantDataWithSortType:typeStr];
    }
}

- (void)filterByInfo:(NSInteger)type {
    NSString *typeStr = @"";
    switch (type) {
        case TCDeliver:
            
            break;
        case TCReserve:
            
            break;
        default:
            break;
    }
    if (![typeStr isEqualToString:@""]) {
        [self loadRestaurantDataWithSortType:typeStr];
    }

}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [filterView hiddenAllView];
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
