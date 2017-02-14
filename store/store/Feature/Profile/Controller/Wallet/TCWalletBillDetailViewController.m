//
//  TCWalletBillDetailViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillDetailViewController.h"

#import "TCWalletBillDetailHeaderView.h"
#import "TCWalletBillDetailViewCell.h"

#import "TCWalletBill.h"

@interface TCWalletBillDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TCWalletBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"账单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 66;
    self.tableView.tableFooterView = [UIView new];
    
    TCWalletBillDetailHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TCWalletBillDetailHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"TCWalletBillDetailViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCWalletBillDetailViewCell"];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma makr - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCWalletBillDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCWalletBillDetailViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"流水号";
            cell.detailLabel.text = self.walletBill.ID;
            break;
        case 1:
            cell.titleLabel.text = @"交易时间";
            cell.detailLabel.text = self.walletBill.tradingTime;
            break;
        case 2:
            cell.titleLabel.text = @"交易金额";
            cell.detailLabel.text = [NSString stringWithFormat:@"%0.2f", self.walletBill.amount];
            break;
        case 3:
            cell.titleLabel.text = @"商家名称";
            cell.detailLabel.text = @"";
            break;
        default:
            break;
    }
    return cell;
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
