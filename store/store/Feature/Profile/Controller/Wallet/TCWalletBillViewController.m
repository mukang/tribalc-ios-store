//
//  TCWalletBillViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillViewController.h"
#import "TCWalletBillDetailViewController.h"

#import "TCWalletBillViewCell.h"

#import "TCBuluoApi.h"

#import "TCRefreshHeader.h"
#import "TCRefreshFooter.h"

@interface TCWalletBillViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *sortSkip;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation TCWalletBillViewController {
    __weak TCWalletBillViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadDataFirstTime];
}

- (void)setupNavBar {
    self.navigationItem.title = @"账单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.backgroundColor = TCRGBColor(242, 242, 242);
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    self.tableView.mj_footer.hidden = YES;
    
    UINib *nib = [UINib nibWithNibName:@"TCWalletBillViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCWalletBillViewCell"];
}

- (void)loadDataFirstTime {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletBillWrapper:nil count:20 sortSkip:nil result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
        if (walletBillWrapper) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.sortSkip = walletBillWrapper.nextSkip;
            if (walletBillWrapper.hasMore) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.dataList removeAllObjects];
            for (TCWalletBill *walletBill in walletBillWrapper.content) {
                NSMutableArray *temp = [weakSelf.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:walletBill];
                    [weakSelf.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([walletBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:walletBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:walletBill];
                        [weakSelf.dataList addObject:newTemp];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
        }
    }];
}

- (void)loadNewData {
    [[TCBuluoApi api] fetchWalletBillWrapper:nil count:20 sortSkip:nil result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (walletBillWrapper) {
            weakSelf.sortSkip = walletBillWrapper.nextSkip;
            if (walletBillWrapper.hasMore) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.dataList removeAllObjects];
            for (TCWalletBill *walletBill in walletBillWrapper.content) {
                NSMutableArray *temp = [weakSelf.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:walletBill];
                    [weakSelf.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([walletBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:walletBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:walletBill];
                        [weakSelf.dataList addObject:newTemp];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
        }
    }];
}

- (void)loadOldData {
    [[TCBuluoApi api] fetchWalletBillWrapper:nil count:20 sortSkip:self.sortSkip result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (walletBillWrapper) {
            weakSelf.sortSkip = walletBillWrapper.nextSkip;
            if (!walletBillWrapper.hasMore) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (TCWalletBill *walletBill in walletBillWrapper.content) {
                NSMutableArray *temp = [weakSelf.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:walletBill];
                    [weakSelf.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([walletBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:walletBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:walletBill];
                        [weakSelf.dataList addObject:newTemp];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
        }
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *temp = self.dataList[section];
    return temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCWalletBillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCWalletBillViewCell" forIndexPath:indexPath];
    NSMutableArray *temp = self.dataList[indexPath.section];
    cell.walletBill = temp[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *temp = self.dataList[section];
    TCWalletBill *walletBill = temp[0];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCRGBColor(242, 242, 242);
    UILabel *label = [[UILabel alloc] init];
    label.text = walletBill.monthDate;
    label.textColor = TCRGBColor(42, 42, 42);
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(20, 0, 100, 21);
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *temp = self.dataList[indexPath.section];
    TCWalletBill *walletBill = temp[indexPath.row];
    
    TCWalletBillDetailViewController *vc = [[TCWalletBillDetailViewController alloc] initWithNibName:@"TCWalletBillDetailViewController" bundle:[NSBundle mainBundle]];
    vc.walletBill = walletBill;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
