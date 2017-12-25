//
//  TCProfileViewController.m
//  store
//
//  Created by 穆康 on 2017/1/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewController.h"
#import "TCLoginViewController.h"
#import "TCNavigationController.h"
#import "TCQRCodeViewController.h"
#import "TCAppSettingViewController.h"
#import "TCInfoViewController.h"
#import "TCStoreCategoryViewController.h"
#import "TCStoreSettingViewController.h"
#import "TCGoodsStoreSettingViewController.h"
#import "TCWalletViewController.h"

#import "TCProfileHeaderView.h"
#import "TCProfileViewCell.h"
#import "TCNavigationBar.h"
#import <TCCommonLibs/TCPhotoModeView.h>

#import "TCBuluoApi.h"
#import "TCPhotoPicker.h"
#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import "TCBusinessLicenceViewController.h"
#import "TCBussinessAuthSuccessController.h"
#import "TCBussinessAuthFailureAndProcessController.h"

@interface TCProfileViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
TCProfileHeaderViewDelegate,
TCPhotoPickerDelegate,
TCPhotoModeViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCProfileHeaderView *headerView;

@property (weak, nonatomic) TCNavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;
@property (nonatomic) BOOL needsLightContentStatusBar;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGFloat topBarHeight;

@end

@implementation TCProfileViewController {
    __weak TCProfileViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.headerViewHeight = 240.0;
    self.topBarHeight = 64.0;
    
    [self setupNavBar];
    [self setupSubviews];
    [self updateHeaderView];
    [self registerNotifications];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [self removeNotifications];
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    TCNavigationBar *navBar = [[TCNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"商铺"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_QRcode_item"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickQRCodeButton:)];
    navItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_setting_item"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    navItem.rightBarButtonItem = settingItem;
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    [self updateNavigationBarWithAlpha:0.0];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 54;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.navBar];
    self.tableView = tableView;
    
    TCProfileHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TCProfileHeaderView" owner:nil options:nil] firstObject];
    headerView.delegate = self;
    tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"TCProfileViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCProfileViewCell"];
}

- (void)updateHeaderView {
    if ([[TCBuluoApi api] needLogin]) {
        self.headerView.loginButton.hidden = NO;
        self.headerView.nickBgView.hidden = YES;
        [self.headerView.avatarImageView setImage:[UIImage imageNamed:@"profile_default_avatar_icon"]];
        [self.headerView.bgImageView setImage:[UIImage imageNamed:@"profile_default_cover"]];
    } else {
        self.headerView.loginButton.hidden = YES;
        self.headerView.nickBgView.hidden = NO;
        TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
        self.headerView.nickLabel.text = storeInfo.name;
        if (storeInfo.logo) {
            UIImage *currentAvatarImage = self.headerView.avatarImageView.image;
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:storeInfo.logo];
            [self.headerView.avatarImageView sd_setImageWithURL:URL placeholderImage:currentAvatarImage options:SDWebImageRetryFailed];
        } else {
            [self.headerView.avatarImageView setImage:[UIImage imageNamed:@"profile_default_avatar_icon"]];
        }
        
        if (storeInfo.cover) {
            UIImage *currentBgImage = self.headerView.bgImageView.image;
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:storeInfo.cover];
            [self.headerView.bgImageView sd_setImageWithURL:URL placeholderImage:currentBgImage options:SDWebImageRetryFailed];
        } else {
            [self.headerView.bgImageView setImage:[UIImage imageNamed:@"profile_default_cover"]];
        }
    }
}

#pragma mark - Navigation Bar

- (void)updateNavigationBar {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat alpha = offsetY / (self.headerViewHeight - self.topBarHeight);
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *tintColor = nil, *titleColor = nil;
    if (alpha > 0.7) {
        self.needsLightContentStatusBar = YES;
        tintColor = [UIColor whiteColor];
        titleColor = [UIColor whiteColor];
    } else {
        self.needsLightContentStatusBar = NO;
        tintColor = TCBlackColor;
        titleColor = [UIColor clearColor];
    }
    [self.navBar setTintColor:tintColor];
    self.navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : titleColor
                                        };
    
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(42, 42, 42, alpha)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Status Bar

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.needsLightContentStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)setNeedsLightContentStatusBar:(BOOL)needsLightContentStatusBar {
    BOOL statusBarNeedsUpdate = (needsLightContentStatusBar != _needsLightContentStatusBar);
    _needsLightContentStatusBar = needsLightContentStatusBar;
    if (statusBarNeedsUpdate) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCProfileViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"profile_create"];
        NSString *storeType = [[TCBuluoApi api] currentUserSession].storeInfo.storeType;
        if ([storeType isEqualToString:@"GOODS"] || [storeType isEqualToString:@"SET_MEAL"]) {
            cell.titleLabel.text = @"店铺设置";
        } else {
            cell.titleLabel.text = @"创建店铺";
        }
    } else {
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"profile_wallet"];
            cell.titleLabel.text = @"企业钱包";
        } else {
            cell.iconImageView.image = [UIImage imageNamed:@"profile_authentication"];
            cell.titleLabel.text = @"商户认证";
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self checkUserNeedLogin]) return;
    
    if (indexPath.section == 0) { // 创建店铺 或 店铺设置
        [self handleSelectCreateStoreCell];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 钱包
            [self handleSelectWalletCell];
        } else if (indexPath.row == 1) { // 商户认证
            [self handleSelectBussinessAuthCell];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateNavigationBar];
}

#pragma mark - TCProfileHeaderViewDelegate

- (void)didTapBioInProfileHeaderView:(TCProfileHeaderView *)view {
    if ([[TCBuluoApi api] needLogin]) {
        [self showLoginViewController];
    } else {
        TCInfoViewController *vc = [[TCInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didClickCardButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了名片按钮");
    [self btnClickUnifyTips];
    //    if ([self checkUserNeedLogin]) return;
}

- (void)didClickCollectButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了收藏按钮");
    [self btnClickUnifyTips];
    //    if ([self checkUserNeedLogin]) return;
}

- (void)didClickGradeButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了等级按钮");
    [self btnClickUnifyTips];
    //    if ([self checkUserNeedLogin]) return;
}

- (void)didClickPhotographButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    if ([self checkUserNeedLogin]) return;
    
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

#pragma mark - TCPhotoModeViewDelegate

- (void)didClickCameraButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    self.photoPicker = photoPicker;
}

- (void)didClickAlbumButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.photoPicker = photoPicker;
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
    
    UIImage *coverImage;
    if (info[UIImagePickerControllerEditedImage]) {
        coverImage = info[UIImagePickerControllerEditedImage];
    } else {
        coverImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] uploadImage:coverImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        if (success) {
            [weakSelf changeStoreCoverWithName:uploadInfo.objectKey];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

#pragma mark - Show Login View Controller

- (BOOL)checkUserNeedLogin {
    if ([[TCBuluoApi api] needLogin]) {
        [self showLoginViewController];
    }
    return [[TCBuluoApi api] needLogin];
}

- (void)showLoginViewController {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogin:) name:TCBuluoApiNotificationUserDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogout:) name:TCBuluoApiNotificationUserDidLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStoreInfoDidUpdate:) name:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStoreDidCreated:) name:TCBuluoApiNotificationStoreDidCreated object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions

- (void)changeStoreCoverWithName:(NSString *)name {
    NSString *imagePath = [TCImageURLSynthesizer synthesizeImagePathWithName:name source:kTCImageSourceOSS];
    [[TCBuluoApi api] changeStoreCover:imagePath result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf updateHeaderView];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (void)handleClickQRCodeButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了扫码按钮");
    if ([self checkUserNeedLogin]) return;
    TCQRCodeViewController *qrVc = [[TCQRCodeViewController alloc] init];
    qrVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrVc animated:YES];
}

- (void)handleClickSettingButton:(UIBarButtonItem *)sender {
    if ([self checkUserNeedLogin]) return;
    
    TCAppSettingViewController *vc = [[TCAppSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSelectCreateStoreCell {
    NSString *storeType = [[TCBuluoApi api] currentUserSession].storeInfo.storeType;
    if ([storeType isEqualToString:@"GOODS"]) {
        TCGoodsStoreSettingViewController *vc = [[TCGoodsStoreSettingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([storeType isEqualToString:@"SET_MEAL"]) {
        TCStoreSettingViewController *vc = [[TCStoreSettingViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TCStoreCategoryViewController *vc = [[TCStoreCategoryViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)handleSelectWalletCell {
    TCWalletViewController *vc = [[TCWalletViewController alloc] initWithNibName:@"TCWalletViewController" bundle:[NSBundle mainBundle]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSelectBussinessAuthCell {
    
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreAuthenticationInfo:^(TCAuthenticationInfo *authenticationInfo, NSError *error) {
        @StrongObj(self)
        if (authenticationInfo) {
            [MBProgressHUD hideHUD:YES];
            
            NSString *authStr = authenticationInfo.authenticationStatus;
            if ([authStr isEqualToString:@"NOT_START"]) {
                TCBusinessLicenceViewController *businessVC = [[TCBusinessLicenceViewController alloc] init];
                businessVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:businessVC animated:YES];
            }else if ([authStr isEqualToString:@"FAILURE"] || [authStr isEqualToString:@"PROCESSING"]) {
                TCBussinessAuthFailureAndProcessController *bussVc = [[TCBussinessAuthFailureAndProcessController alloc] initWithAuthStatus:authStr];
                bussVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bussVc animated:YES];
            }else if ([authStr isEqualToString:@"SUCCESS"]) {
                TCBussinessAuthSuccessController *successVc = [[TCBussinessAuthSuccessController alloc] init];
                successVc.hidesBottomBarWhenPushed = YES;
                successVc.authenticationInfo = authenticationInfo;
                [self.navigationController pushViewController:successVc animated:YES];
            }
            
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
    
}

- (void)handleUserDidLogin:(id)sender {
    [self updateHeaderView];
    [self.tableView reloadData];
}

- (void)handleUserDidLogout:(id)sender {
    [self updateHeaderView];
    [self.tableView reloadData];
}

- (void)handleStoreInfoDidUpdate:(id)sender {
    [self updateHeaderView];
}

- (void)handleStoreDidCreated:(id)sender {
    [self updateHeaderView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
