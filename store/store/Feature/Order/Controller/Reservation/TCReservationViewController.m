//
//  TCReservationViewController.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationViewController.h"
#import "TCReservationDetailViewController.h"

#import "TCReservationViewCell.h"

#import "TCRefreshHeader.h"
#import "TCRefreshFooter.h"

#import "TCBuluoApi.h"

@interface TCReservationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@property (nonatomic) NSInteger limitSize;
@property (copy, nonatomic) NSString *sortSkip;

@end

@implementation TCReservationViewController {
    __weak TCReservationViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.limitSize = 20;
    self.navigationItem.title = @"预定管理";
    
    [self setupSubviews];
    [self loadNewData];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 188.5;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCReservationViewCell class] forCellReuseIdentifier:@"TCReservationViewCell"];
    tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
}

- (void)loadNewData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchReservationWrapper:self.limitSize sortSkip:nil result:^(TCReservationWrapper *reservationWrapper, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (reservationWrapper) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:reservationWrapper.content];
            weakSelf.sortSkip = reservationWrapper.nextSkip;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    [[TCBuluoApi api] fetchReservationWrapper:self.limitSize sortSkip:self.sortSkip result:^(TCReservationWrapper *reservationWrapper, NSError *error) {
        if (reservationWrapper) {
            if (reservationWrapper.hasMore) {
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.dataList addObjectsFromArray:reservationWrapper.content];
            weakSelf.sortSkip = reservationWrapper.nextSkip;
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCReservationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCReservationViewCell" forIndexPath:indexPath];
    cell.reservation = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCReservationDetailViewController *vc = [[TCReservationDetailViewController alloc] init];
    TCReservation *reservation = self.dataList[indexPath.row];
    vc.reservationID = reservation.ID;
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
