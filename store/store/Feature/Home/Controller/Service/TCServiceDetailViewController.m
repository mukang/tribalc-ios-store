//
//  TCServiceDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/2/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceDetailViewController.h"
#import "TCServiceLocationViewController.h"
#import "TCServiceFacilitiesViewController.h"

#import "TCServiceHeaderView.h"
#import "TCServiceNameViewCell.h"
#import "TCServiceAddressViewCell.h"
#import "TCServiceRecommendViewCell.h"
#import "TCServicePromptViewCell.h"

#import "UIImage+Category.h"

#import "TCBuluoApi.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import <MAMapKit/MAMapKit.h>

#define headerViewH TCRealValue(270)
#define navBarH     64.0

@interface TCServiceDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TCServiceAddressViewCellDelegate>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCServiceHeaderView *headerView;

@property (strong, nonatomic) TCServiceDetail *serviceDetail;

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation TCServiceDetailViewController {
    __weak TCServiceDetailViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBarH)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_black_bg_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    [self updateNavigationBarWithAlpha:0.0];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(headerViewH, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCServiceNameViewCell class] forCellReuseIdentifier:@"TCServiceNameViewCell"];
    [tableView registerClass:[TCServiceAddressViewCell class] forCellReuseIdentifier:@"TCServiceAddressViewCell"];
    [tableView registerClass:[TCServiceRecommendViewCell class] forCellReuseIdentifier:@"TCServiceRecommendViewCell"];
    [tableView registerClass:[TCServicePromptViewCell class] forCellReuseIdentifier:@"TCServicePromptViewCell"];
    [self.view insertSubview:tableView belowSubview:self.navBar];
    self.tableView = tableView;
    
    TCServiceHeaderView *headerView = [[TCServiceHeaderView alloc] init];
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
    }];
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchServiceDetail:self.serviceID result:^(TCServiceDetail *serviceDetail, NSError *error) {
        if (serviceDetail) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf addDistanceInServiceDetail:serviceDetail];
            [weakSelf updateUIWithServiceDetail:serviceDetail];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)addDistanceInServiceDetail:(TCServiceDetail *)serviceDetail {
    NSArray *coordinateArr = [[NSUserDefaults standardUserDefaults] objectForKey:TCBuluoUserLocationCoordinateKey];
    if ([coordinateArr isKindOfClass:[NSArray class]] && coordinateArr.count == 2) {
        CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake([coordinateArr[0] doubleValue], [coordinateArr[1] doubleValue]);
        MAMapPoint point1 = MAMapPointForCoordinate(userCoordinate);
        if (serviceDetail.detailStore.coordinate) {
            MAMapPoint point2 = MAMapPointForCoordinate(serviceDetail.detailStore.coordinate2D);
            serviceDetail.detailStore.distance = MAMetersBetweenMapPoints(point1,point2) / 1000;
        }
    }
}

- (void)updateUIWithServiceDetail:(TCServiceDetail *)serviceDetail {
    self.navItem.title = serviceDetail.name;
    self.serviceDetail = serviceDetail;
    self.headerView.detailStore = serviceDetail.detailStore;
    [weakSelf.tableView reloadData];
}

- (void)updateHeaderView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY > 0) return;
    if (offsetY > -headerViewH) {
        offsetY = -headerViewH;
    }
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView).offset(offsetY);
        make.height.mas_equalTo(-offsetY);
    }];
}

#pragma mark - Navigation Bar

- (void)updateNavigationBar {
    CGFloat maxOffsetY = headerViewH;
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat alpha = (offsetY + headerViewH) / maxOffsetY;
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *titleColor = nil;
    if (alpha > 0.7) {
        titleColor = [UIColor whiteColor];
    } else {
        titleColor = [UIColor clearColor];
    }
    self.navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : titleColor
                                        };
    
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(42, 42, 42, alpha)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.serviceDetail) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.row) {
        case 0:
        {
            TCServiceNameViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCServiceNameViewCell" forIndexPath:indexPath];
            cell.serviceDetail = self.serviceDetail;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCServiceAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCServiceAddressViewCell" forIndexPath:indexPath];
            TCDetailStore *detailStore = self.serviceDetail.detailStore;
            cell.phoneLabel.text = detailStore.phone;
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", detailStore.province, detailStore.city, detailStore.district, detailStore.address];
            cell.delegate = self;
            currentCell = cell;
        }
            break;
        case 2:
        case 3:
        {
            TCServiceRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCServiceRecommendViewCell" forIndexPath:indexPath];
            if (indexPath.row == 2) {
                cell.type = TCServiceRecommendViewCellTypeReason;
                cell.content = self.serviceDetail.recommendedReason;
            } else {
                cell.type = TCServiceRecommendViewCellTypeTopics;
                cell.content = self.serviceDetail.topics;
            }
            currentCell = cell;
        }
            break;
        case 4:
        {
            TCServicePromptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCServicePromptViewCell" forIndexPath:indexPath];
            cell.detailStore = self.serviceDetail.detailStore;
            currentCell = cell;
        }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 145;
            break;
        case 1:
            height = 82;
            break;
        case 2:
        {
            height = [tableView fd_heightForCellWithIdentifier:@"TCServiceRecommendViewCell"
                                              cacheByIndexPath:indexPath
                                                 configuration:^(TCServiceRecommendViewCell *cell) {
                                                     cell.type = TCServiceRecommendViewCellTypeReason;
                                                     cell.content = self.serviceDetail.recommendedReason;
                                                 }];
        }
            break;
        case 3:
        {
            height = [tableView fd_heightForCellWithIdentifier:@"TCServiceRecommendViewCell"
                                              cacheByIndexPath:indexPath
                                                 configuration:^(TCServiceRecommendViewCell *cell) {
                                                     cell.type = TCServiceRecommendViewCellTypeTopics;
                                                     cell.content = self.serviceDetail.topics;
                                                 }];
        }
            break;
        case 4:
            height = 138.5;
            break;
            
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.serviceDetail.detailStore.facilities.count) {
        TCServiceFacilitiesViewController *vc = [[TCServiceFacilitiesViewController alloc] init];
        vc.facilities = self.serviceDetail.detailStore.facilities;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
    [self updateNavigationBar];
}

#pragma mark - TCServiceAddressViewCellDelegate

- (void)didClickPhoneButtonInServiceAddressViewCell:(TCServiceAddressViewCell *)cell {
    NSString *phone = self.serviceDetail.detailStore.phone;
    if (!phone) {
        return;
    }
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSString *URLString = [NSString stringWithFormat:@"tel://%@", phone];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
}

- (void)didClickAddressButtonInServiceAddressViewCell:(TCServiceAddressViewCell *)cell {
    if (!self.serviceDetail.detailStore.coordinate) return;
    
    TCServiceLocationViewController *vc = [[TCServiceLocationViewController alloc] init];
    vc.detailStore = self.serviceDetail.detailStore;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
