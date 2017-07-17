//
//  TCStoreViewController.m
//  store
//
//  Created by 王帅锋 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreViewController.h"
#import "TCNavigationController.h"
#import "TCCollectViewController.h"
#import "TCSettingViewController.h"
#import "TCStoreInfo.h"
#import "TCBuluoApi.h"
#import "TCVerticalImageAndTitleBtn.h"
#import <UIImage+Category.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import "TCWalletBillViewController.h"
#import "TCBankCardViewController.h"
#import "TCWalletAccount.h"
#import "TCWithdrawViewController.h"
#import "TCStoreSettingViewController.h"

@interface TCStoreViewController ()

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *messageArr;

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (weak, nonatomic) UILabel *balanceLabel;

@end

@implementation TCStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setUpViews];
    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchHomeMessageWithLimit:0 createDate:0 isNew:nil result:^(NSArray *messageArr, NSError *error) {
        @StrongObj(self)
        if ([messageArr isKindOfClass:[NSArray class]]) {
            [MBProgressHUD hideHUD:YES];
            self.messageArr = messageArr;
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showHUDWithMessage:@"获取失败" afterDelay:1.0];
        }
    }];
}

- (void)fetchWallatData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        @StrongObj(self)
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            self.walletAccount = walletAccount;
            NSString *str = [NSString stringWithFormat:@"¥%.2f", walletAccount.balance];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, 1)];
            self.balanceLabel.attributedText = attributedStr;
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败！"];
        }
    }];
}



- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)col {
    TCCollectViewController *collectVC = [[TCCollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchWallatData];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
    navBar.barTintColor = [UIColor whiteColor];
//    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(255, 255, 255, 1)];
//    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:[[TCBuluoApi api] currentUserSession].storeInfo.name];

    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile_nav_setting_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    navItem.rightBarButtonItem = settingItem;
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)handleClickSettingButton:(UIBarButtonItem *)item {
    TCStoreSettingViewController *vc = [[TCStoreSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bill {
    TCWalletBillViewController *billVC = [[TCWalletBillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)discount {
    
}

- (void)card {
    TCBankCardViewController *bankCardVC = [[TCBankCardViewController alloc] init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

- (void)cash {
    TCWithdrawViewController *withDrawVC = [[TCWithdrawViewController alloc] initWithWalletAccount:self.walletAccount];
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TCRealValue(238))];
        _tableView.tableHeaderView = headerView;
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TCRealValue(135))];
        [headerView addSubview:topImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(58), (TCRealValue(135)-TCRealValue(70))/2, TCRealValue(70), TCRealValue(70))];
        iconImageView.layer.cornerRadius = TCRealValue(70)/2;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImageView.layer.borderWidth = 2.0;
        [topImageView addSubview:iconImageView];
        if (storeInfo.logo) {
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:storeInfo.logo];
            [iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        } else {
            [iconImageView setImage:[UIImage imageNamed:@"profile_default_avatar_icon"]];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+TCRealValue(75), TCRealValue(35), self.view.frame.size.width-CGRectGetMaxX(iconImageView.frame)-TCRealValue(75)-20, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"会员卡余额";
        [topImageView addSubview:titleLabel];
        
        UILabel *banlanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+TCRealValue(10), titleLabel.frame.size.width, TCRealValue(40))];
        banlanceLabel.textColor = [UIColor whiteColor];
        banlanceLabel.font = [UIFont systemFontOfSize:42];
        NSString *str = [NSString stringWithFormat:@"¥%f", storeInfo.balance];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, 1)];
        banlanceLabel.attributedText = attributedStr;
        [topImageView addSubview:banlanceLabel];
        self.balanceLabel = banlanceLabel;
        
//        if ([storeInfo.accountType isKindOfClass:[NSString class]]) {
//            if ([storeInfo.accountType isEqualToString:@"CARD"]) {
                topImageView.image = [UIImage imageNamed:@"colBg"];
                CGFloat width = self.view.bounds.size.width / 3;
                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"collection" title:@"收款"];
                [headerView addSubview:colBtn];
        [colBtn addTarget:self action:@selector(col) forControlEvents:UIControlEventTouchUpInside];
        
                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"bill" title:@"对账单"];
                [headerView addSubview:billBtn];
        [billBtn addTarget:self action:@selector(bill) forControlEvents:UIControlEventTouchUpInside];
                
                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"discount" title:@"优惠策略"];
                [headerView addSubview:discountBtn];
        [discountBtn addTarget:self action:@selector(discount) forControlEvents:UIControlEventTouchUpInside];
                
//            }else if ([storeInfo.accountType isEqualToString:@"PROTOCOL"]) {
//                topImageView.image = [UIImage imageNamed:@"cashBg"];
//                CGFloat width = self.view.bounds.size.width / 5;
//                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"collection" title:@"收款"];
//                [headerView addSubview:colBtn];
//                    [colBtn addTarget:self action:@selector(col) forControlEvents:UIControlEventTouchUpInside];
//
//                TCVerticalImageAndTitleBtn *cashBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"cash" title:@"提现"];
//                [headerView addSubview:cashBtn];
//        [cashBtn addTarget:self action:@selector(cash) forControlEvents:UIControlEventTouchUpInside];
//
//                TCVerticalImageAndTitleBtn *cardBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cashBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"card" title:@"银行卡"];
//                [headerView addSubview:cardBtn];
//        [cardBtn addTarget:self action:@selector(card) forControlEvents:UIControlEventTouchUpInside];
//
//                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"bill" title:@"对账单"];
//                [headerView addSubview:billBtn];
//        [billBtn addTarget:self action:@selector(bill) forControlEvents:UIControlEventTouchUpInside];
//
//                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"discount" title:@"优惠策略"];
//                [headerView addSubview:discountBtn];
//        [discountBtn addTarget:self action:@selector(discount) forControlEvents:UIControlEventTouchUpInside];
//            }
//        }
        CGFloat scale = self.view.bounds.size.width > 375.0 ? 3 : 2;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TCRealValue(238)-0.5, self.view.bounds.size.width, 1/scale)];
        lineView.backgroundColor = TCLightGrayColor;
        [headerView addSubview:lineView];
        
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
