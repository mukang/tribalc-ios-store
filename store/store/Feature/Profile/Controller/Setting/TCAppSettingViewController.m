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
#import "TCBankCardViewController.h"
#import "TCStoreDetailViewController.h"
#import "TCWalletPasswordViewController.h"
#import "TCAppNotificationViewCell.h"
#import "TCAppCacheViewCell.h"
#import "TCBuluoApi.h"
#import "TCWalletAccount.h"
#import "TCAppGoodsManageCell.h"
#import "TCUserDefaultsKeys.h"
#import "TCBioEditPhoneViewController.h"
#import "TCBioEditPhoneController.h"
#import "TCIDAuthDetailViewController.h"
#import "TCIDAuthViewController.h"

#import <TCCommonLibs/TCCommonIndicatorViewCell.h>
#import <TCCommonLibs/TCCommonButton.h>
#import <SDImageCache.h>


@interface TCAppSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

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
    self.tableView = tableView;
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        TCAppGoodsManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppGoodsManageCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 8) {
        TCAppNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppNotificationViewCell" forIndexPath:indexPath];
            return cell;
    }else if(indexPath.row == 5) {
        TCAppCacheViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCAppCacheViewCell" forIndexPath:indexPath];
        return cell;
    }else{
        TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"商户信息";
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"商户认证";
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"修改手机号";
            cell.subtitleLabel.text = [TCBuluoApi api].currentUserSession.storeInfo.phone;
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
        } else if (indexPath.row == 4) {
            cell.titleLabel.text = @"支付密码";
        } else if (indexPath.row == 6) {
            cell.titleLabel.text = @"意见反馈";
        } else if (indexPath.row == 7) {
            cell.titleLabel.text = @"关于我们";
        } else if (indexPath.row == 9) {
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
        case 4:
            //支付密码
            [self handleClickPassword];
            break;
        case 3:
            //清除缓存
            break;
        case 6:
        {
            TCSuggestionViewController *vc = [[TCSuggestionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            TCAboutUSViewController *aboutUs = [[TCAboutUSViewController alloc] init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 9:
        {
            TCMessageManagementViewController *vc = [[TCMessageManagementViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            [self handleSelectPhoneCell];
        }
            break;
            case 1:
        {
            [self handleClickIdentityCell];
        }
        default:
            break;
    }
}


#pragma mark - Actions

- (void)handleClickIdentityCell {
    TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
    UIViewController *currentVC;
    if ([storeInfo.authorizedStatus isEqualToString:@"PROCESSING"]) {
        TCIDAuthDetailViewController *vc = [[TCIDAuthDetailViewController alloc] initWithIDAuthStatus:TCIDAuthStatusProcessing];
        currentVC = vc;
    } else if ([storeInfo.authorizedStatus isEqualToString:@"SUCCESS"] || [storeInfo.authorizedStatus isEqualToString:@"FAILURE"]) {
        TCIDAuthDetailViewController *vc = [[TCIDAuthDetailViewController alloc] initWithIDAuthStatus:TCIDAuthStatusFinished];
        currentVC = vc;
    } else {
        TCIDAuthViewController *vc = [[TCIDAuthViewController alloc] initWithNibName:@"TCIDAuthViewController" bundle:[NSBundle mainBundle]];
        currentVC = vc;
    }
    currentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:currentVC animated:YES];
}


- (void)handleSelectPhoneCell {
    TCBioEditPhoneController *editPhoneVC = [[TCBioEditPhoneController alloc] initWithNibName:@"TCBioEditPhoneController" bundle:[NSBundle mainBundle]];
    editPhoneVC.editPhoneBlock = ^(BOOL edited){
        if (edited) {
            [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:editPhoneVC animated:YES];
}

- (void)fetchBankCardsList {
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] fetchBankCardList:^(NSArray *bankCardList, NSError *error) {
        @StrongObj(self)
        [MBProgressHUD hideHUD:YES];
        if (!error) {
            if ([bankCardList isKindOfClass:[NSArray class]] && bankCardList.count > 0) {
                // 弹出解绑银行卡提示
                [self tips];
            }else {
                //
            }
        }
    }];
}

- (void)tips {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先解绑个人银行卡才能修改手机号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"去解绑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self toBankCardList];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)toBankCardList {
    TCBankCardViewController *bankCardVC = [[TCBankCardViewController alloc] init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

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
