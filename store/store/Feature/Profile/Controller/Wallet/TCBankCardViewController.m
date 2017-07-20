//
//  TCBankCardViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankCardViewController.h"
#import "TCBankCardAddViewController.h"

#import "TCBankCardViewCell.h"

#import "TCBuluoApi.h"

@interface TCBankCardViewController () <UITableViewDataSource, UITableViewDelegate, TCBankCardViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBankCardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (copy, nonatomic) NSArray *bankInfoList;

@end

@implementation TCBankCardViewController {
    __weak TCBankCardViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupSubviews];
    if (self.isForWithdraw) {
        self.navigationItem.title = @"银行卡";
        self.addBankCardButton.hidden = YES;
        self.bottomConstraint.constant = 0;
    } else {
        [self setupNavBar];
        [self loadNetData];
    }
}

- (void)setupNavBar {
    self.navigationItem.title = @"银行卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickEditButton:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    self.tableView.backgroundColor = TCBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 132.5;
    
    UINib *nib = [UINib nibWithNibName:@"TCBankCardViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCBankCardViewCell"];
}

- (void)loadNetData {
    [[TCBuluoApi api] fetchBankCardList:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:bankCardList];
            weakSelf.walletAccount.bankCards = [NSArray arrayWithArray:weakSelf.dataList];
            for (TCBankCard *bankCard in weakSelf.dataList) {
                for (NSDictionary *bankInfo in weakSelf.bankInfoList) {
                    if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                        bankCard.logo = bankInfo[@"logo"];
                        bankCard.bgImage = bankInfo[@"bgImage"];
                        break;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取银行卡信息失败，%@", reason]];
        }
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCBankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBankCardViewCell" forIndexPath:indexPath];
    cell.bankCard = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isForWithdraw) {
        TCBankCard *bankCard = self.dataList[indexPath.row];
        if (self.selectedCompletion) {
            self.selectedCompletion(bankCard);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TCBankCardViewCellDelegate

- (void)bankCardViewCell:(TCBankCardViewCell *)cell didClickDeleteButtonWithBankCard:(TCBankCard *)bankCard {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要删除该银行卡？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf handleDeleteBankCard:bankCard];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)handleClickAddBankCardButton:(UIButton *)sender {
    NSString *authenticationStatus = [TCBuluoApi api].currentUserSession.storeInfo.authenticationStatus;
    if ([authenticationStatus isEqualToString:@"SUCCESS"]) {
        [weakSelf pushBankCardAddViewController];
    } else {
        [MBProgressHUD showHUD:YES];
        [[TCBuluoApi api] fetchStoreAuthenticationInfo:^(TCAuthenticationInfo *authenticationInfo, NSError *error) {
            if (authenticationInfo) {
                if ([authenticationInfo.authenticationStatus isEqualToString:@"SUCCESS"]) {
                    [MBProgressHUD hideHUD:YES];
                    [weakSelf pushBankCardAddViewController];
                } else {
                    [MBProgressHUD showHUDWithMessage:@"商户认证成功后，才可以添加银行卡"];
                }
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取信息失败，%@", reason]];
            }
        }];
    }
}

- (void)pushBankCardAddViewController {
    TCBankCardAddViewController *vc = [[TCBankCardAddViewController alloc] initWithNibName:@"TCBankCardAddViewController" bundle:[NSBundle mainBundle]];
    vc.bankCardAddBlock = ^() {
        [weakSelf loadNetData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickEditButton:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickDoneButton:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
    
    if (self.dataList.count == 0) {
        return;
    }
    for (TCBankCard *bankCard in self.dataList) {
        bankCard.showDelete = YES;
    }
    [self.tableView reloadData];
}

- (void)handleClickDoneButton:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickEditButton:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
    
    if (self.dataList.count == 0) {
        return;
    }
    for (TCBankCard *bankCard in self.dataList) {
        bankCard.showDelete = NO;
    }
    [self.tableView reloadData];
}

- (void)handleDeleteBankCard:(TCBankCard *)bankCard {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] deleteBankCard:bankCard.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf.dataList removeObject:bankCard];
            weakSelf.walletAccount.bankCards = [NSArray arrayWithArray:weakSelf.dataList];
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"银行卡删除失败，%@", reason]];
        }
    }];
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
}

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:walletAccount.bankCards];
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
