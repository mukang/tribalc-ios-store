//
//  TCAppSettingViewController.m
//  store
//
//  Created by 穆康 on 2017/1/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppSettingViewController.h"
#import "TCSuggestionViewController.h"
#import "TCAboutUSViewController.h"
#import "TCMessageManagementViewController.h"

#import <TCCommonLibs/TCCommonIndicatorViewCell.h>
#import "TCAppNotificationViewCell.h"
#import "TCAppCacheViewCell.h"
#import <TCCommonLibs/TCCommonButton.h>

#import "TCBuluoApi.h"
#import <SDImageCache.h>
#import "TCStoreDetailViewController.h"
#import "TCWalletAccount.h"
#import "TCWalletPasswordViewController.h"
#import "TCAppGoodsManageCell.h"
#import "TCUserDefaultsKeys.h"

@interface TCAppSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TCAppSettingViewController {
    __weak TCAppSettingViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 54;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCAppNotificationViewCell class] forCellReuseIdentifier:@"TCAppNotificationViewCell"];
    [tableView registerClass:[TCAppCacheViewCell class] forCellReuseIdentifier:@"TCAppCacheViewCell"];
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCAppGoodsManageCell class] forCellReuseIdentifier:@"TCAppGoodsManageCell"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    tableView.tableFooterView = footerView;
    
    TCCommonButton *logouButton = [TCCommonButton buttonWithTitle:@"退出" target:self action:@selector(handleClickLogoutButton:)];
    [footerView addSubview:logouButton];
    
    
    [logouButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).with.offset(30);
        make.right.equalTo(footerView.mas_right).with.offset(-30);
        make.top.equalTo(footerView).offset(40);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        TCAppGoodsManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppGoodsManageCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 6) {
        TCAppNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppNotificationViewCell" forIndexPath:indexPath];
            return cell;
    }else if(indexPath.row == 3) {
        TCAppCacheViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppCacheViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"商户信息";
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"支付密码";
        } else if (indexPath.row == 4) {
            cell.titleLabel.text = @"意见反馈";
        } else if (indexPath.row == 5) {
            cell.titleLabel.text = @"关于我们";
        } else if (indexPath.row == 7) {
            cell.titleLabel.text = @"消息管理";
        }
        return cell;

    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            //商家信息
            {
                TCStoreDetailViewController *storeVC = [[TCStoreDetailViewController alloc] init];
                [self.navigationController pushViewController:storeVC animated:YES];
            }
            break;
        case 2:
            //支付密码
            [self handleClickPassword];
            break;
        case 3:
            //清除缓存
            break;
        case 4:
        {
            TCSuggestionViewController *vc = [[TCSuggestionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            TCAboutUSViewController *aboutUs = [[TCAboutUSViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 7:
        {
            TCMessageManagementViewController *vc = [[TCMessageManagementViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - Actions

- (void)handleClickPassword {
    if (!self.walletAccount) {
        [MBProgressHUD showHUDWithMessage:@"暂时无法设置支付密码"];
        return;
    }
    TCWalletPasswordType passwordType;
    NSString *oldPassword;
    if (self.walletAccount.password) {
        passwordType = TCWalletPasswordTypeResetInputOldPassword;
        oldPassword = self.walletAccount.password;
    } else {
        passwordType = TCWalletPasswordTypeFirstTimeInputPassword;
    }
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:passwordType];
    vc.oldPassword = oldPassword;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickLogoutButton:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleUserLogout];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)handleUserLogout {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[TCBuluoApi api] logout:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:TCUserDefaultsKeySwitchGoodManage];
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
