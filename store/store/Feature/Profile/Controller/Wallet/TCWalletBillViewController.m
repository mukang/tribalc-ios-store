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

#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>

@interface TCWalletBillViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *sortSkip;
@property (strong, nonatomic) NSMutableArray *dataList;

@property (strong, nonatomic) UIView *noBillView;

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
    self.tableView.backgroundColor = TCBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    self.tableView.mj_footer.hidden = YES;
    
    UINib *nib = [UINib nibWithNibName:@"TCWalletBillViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCWalletBillViewCell"];
    
    self.noBillView = [[UIView alloc] init];
    self.noBillView.hidden = YES;
    [self.view addSubview:self.noBillView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"noBill"];
    [self.noBillView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无收入";
    label.textColor = TCBlackColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [self.noBillView addSubview:label];
    
    [self.noBillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TCRealValue(165));
        make.right.left.equalTo(self.view);
        make.height.equalTo(@(TCRealValue(110)));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.noBillView);
        make.width.height.equalTo(@(TCRealValue(77)));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.noBillView);
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(13));
    }];
}

- (void)loadDataFirstTime {
    [MBProgressHUD showHUD:YES];
    if (self.isWithDraw) {
        [[TCBuluoApi api] fetchWithDrawRequestListWithAccountType:self.accountType limitSize:20 sortSkip:nil sort:@"time,desc" result:^(TCWithDrawRequestWrapper *withDrawRequestWrapper, NSError *error) {
            if (withDrawRequestWrapper) {
                [MBProgressHUD hideHUD:YES];
                weakSelf.sortSkip = withDrawRequestWrapper.nextSkip;
                if (withDrawRequestWrapper.hasMore) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }
                [weakSelf.dataList removeAllObjects];
                for (TCWithDrawRequest *withDrawRequest in withDrawRequestWrapper.content) {
                    NSMutableArray *temp = [weakSelf.dataList lastObject];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [temp addObject:withDrawRequest];
                        [weakSelf.dataList addObject:temp];
                    } else {
                        TCWithDrawRequest *lastWithDrawRequest = [temp lastObject];
                        if ([withDrawRequest.monthDate isEqualToString:lastWithDrawRequest.monthDate]) {
                            [temp addObject:withDrawRequest];
                        } else {
                            NSMutableArray *newTemp = [NSMutableArray array];
                            [newTemp addObject:withDrawRequest];
                            [weakSelf.dataList addObject:newTemp];
                        }
                    }
                }
                [weakSelf.tableView reloadData];
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }
        }];
    }else {
        [[TCBuluoApi api] fetchWalletBillWrapper:self.tradingType count:20 sortSkip:nil face2face:self.face2face result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
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
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }
        }];
    }
    
}

- (void)loadNewData {
    if (self.isWithDraw) {
        [[TCBuluoApi api] fetchWithDrawRequestListWithAccountType:self.accountType limitSize:20 sortSkip:nil sort:@"time,desc" result:^(TCWithDrawRequestWrapper *withDrawRequestWrapper, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (withDrawRequestWrapper) {
                weakSelf.sortSkip = withDrawRequestWrapper.nextSkip;
                if (withDrawRequestWrapper.hasMore) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }
                [weakSelf.dataList removeAllObjects];
                for (TCWithDrawRequest *withDrawRequest in withDrawRequestWrapper.content) {
                    NSMutableArray *temp = [weakSelf.dataList lastObject];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [temp addObject:withDrawRequest];
                        [weakSelf.dataList addObject:temp];
                    } else {
                        TCWithDrawRequest *lastWithDrawRequest = [temp lastObject];
                        if ([withDrawRequest.monthDate isEqualToString:lastWithDrawRequest.monthDate]) {
                            [temp addObject:withDrawRequest];
                        } else {
                            NSMutableArray *newTemp = [NSMutableArray array];
                            [newTemp addObject:withDrawRequest];
                            [weakSelf.dataList addObject:newTemp];
                        }
                    }
                }
                [weakSelf.tableView reloadData];
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }

        }];
    }else {
        [[TCBuluoApi api] fetchWalletBillWrapper:self.tradingType count:20 sortSkip:nil face2face:self.face2face result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
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
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
                
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }
        }];
    }
}

- (void)loadOldData {
    if (self.isWithDraw) {
        [[TCBuluoApi api] fetchWithDrawRequestListWithAccountType:self.accountType limitSize:20 sortSkip:self.sortSkip sort:@"time,desc" result:^(TCWithDrawRequestWrapper *withDrawRequestWrapper, NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            if (withDrawRequestWrapper) {
                weakSelf.sortSkip = withDrawRequestWrapper.nextSkip;
                if (!withDrawRequestWrapper.hasMore) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                for (TCWithDrawRequest *withDrawRequest in withDrawRequestWrapper.content) {
                    NSMutableArray *temp = [weakSelf.dataList lastObject];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [temp addObject:withDrawRequest];
                        [weakSelf.dataList addObject:temp];
                    } else {
                        TCWithDrawRequest *lastWithDrawRequest = [temp lastObject];
                        if ([withDrawRequest.monthDate isEqualToString:lastWithDrawRequest.monthDate]) {
                            [temp addObject:withDrawRequest];
                        } else {
                            NSMutableArray *newTemp = [NSMutableArray array];
                            [newTemp addObject:withDrawRequest];
                            [weakSelf.dataList addObject:newTemp];
                        }
                    }
                }
                [weakSelf.tableView reloadData];
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }

        }];
    }else {
        [[TCBuluoApi api] fetchWalletBillWrapper:self.tradingType count:20 sortSkip:self.sortSkip face2face:self.face2face result:^(TCWalletBillWrapper *walletBillWrapper, NSError *error) {
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
                if (weakSelf.dataList.count) {
                    weakSelf.noBillView.hidden = YES;
                }else {
                    weakSelf.noBillView.hidden = NO;
                }
                
            } else {
                [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
            }
        }];
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
    if (self.isWithDraw) {
        cell.withdrawRequest = temp[indexPath.row];
    }else {
        cell.walletBill = temp[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *temp = self.dataList[section];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCBackgroundColor;
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = TCBlackColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(20, 0, 100, 21);
    [view addSubview:label];
    if (self.isWithDraw) {
        TCWithDrawRequest *withDrawRequest = temp[0];
        label.text = withDrawRequest.monthDate;
        return view;
    }
    TCWalletBill *walletBill = temp[0];
    label.text = walletBill.monthDate;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TCWalletBillDetailViewController *vc = [[TCWalletBillDetailViewController alloc] initWithNibName:@"TCWalletBillDetailViewController" bundle:[NSBundle mainBundle]];

    NSMutableArray *temp = self.dataList[indexPath.section];
    if (self.isWithDraw) {
        TCWithDrawRequest *withDrawRequest = temp[indexPath.row];
        vc.withDrawRequest = withDrawRequest;
    }else {
        TCWalletBill *walletBill = temp[indexPath.row];
        vc.walletBill = walletBill;
    }
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
