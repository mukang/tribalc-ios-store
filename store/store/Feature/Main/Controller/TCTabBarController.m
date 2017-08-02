//
//  TCTabBarController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabBarController.h"
#import "TCNavigationController.h"
#import "TCHomeViewController.h"
#import "TCGoodsViewController.h"
#import "TCOrderViewController.h"
#import "TCProfileViewController.h"
#import "TCLoginViewController.h"
#import "TCLaunchViewController.h"

#import "TCForceUpdateView.h"

#import "TCUserDefaultsKeys.h"

#import <TCCommonLibs/TCFunctions.h>
#import <EAIntroView/EAIntroView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static NSString *const kAppVersion = @"kAppVersion";
static NSString *const AMapApiKey = @"f6e6be9c7571a38102e25077d81a960a";

@interface TCTabBarController () <TCForceUpdateViewDelegate>

@property (strong, nonatomic) UIWindow *updateWindow;
/** 已经显示更新UI，防止重复显示 */
@property (nonatomic) BOOL updateIsShow;

@end

@implementation TCTabBarController {
    __weak TCTabBarController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    
    [self addChildController:[[TCHomeViewController alloc] init] title:@"首页" image:@"tabBar_home_normal" selectedImage:@"tabBar_home_selected"];
    [self addChildController:[[TCGoodsViewController alloc] init] title:@"商品" image:@"tabBar_goods_normal" selectedImage:@"tabBar_goods_selected"];
    [self addChildController:[[TCOrderViewController alloc] init] title:@"订单" image:@"tabBar_order_normal" selectedImage:@"tabBar_order_selected"];
    [self addChildController:[[TCProfileViewController alloc] init] title:@"店铺" image:@"tabBar_profile_normal" selectedImage:@"tabBar_profile_selected"];
    
    [self registerNotifications];
    [self handleShowIntroView];
    [self setupAMapServices];
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)addChildController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selecteImage {
    
    childController.navigationItem.title = title;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:childController];
    
    [nav.tabBarItem setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : TCRGBColor(112, 112, 112)
                                             }
                                  forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : TCRGBColor(67, 67, 67)
                                             }
                                  forState:UIControlStateSelected];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selecteImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    [self addChildViewController:nav];
}

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUnauthorizedNotification:)
                                                 name:TCClientUnauthorizedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAppVersionInfo)
                                                 name:TCLaunchWindowDidDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAppVersionInfo)
                                                 name:TCClientNeedForceUpdateNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleUnauthorizedNotification:(NSNotification *)notification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账号已在其他设备使用，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleUserLogout];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)handleUserLogout {
    [[TCBuluoApi api] logout:^(BOOL success, NSError *error) {
        [weakSelf showLoginViewController];
    }];
}

#pragma mark - Show Login View Controller

- (void)showLoginViewController {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Intro View

/**
 判断是否要显示引导页
 */
- (void)handleShowIntroView {
    if (![self isFirstLaunch]) return;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<3; i++) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"intro_image_%02zd", i+1] ofType:@"png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        EAIntroPage *introPage = [EAIntroPage pageWithCustomView:imageView];
        [tempArray addObject:introPage];
    }
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:tempArray];
    introView.skipButton.hidden = YES;
    introView.pageControl.hidden = YES;
    introView.scrollView.bounces = NO;
    [introView showInView:self.view animateDuration:0];
}

- (BOOL)isFirstLaunch {
    NSString *appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    NSString *currentAppVersion = TCGetAppVersion();
    if (appVersion == nil || ![appVersion isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - AMapServices

- (void)setupAMapServices {
    [AMapServices sharedServices].apiKey = AMapApiKey;
    [AMapServices sharedServices].enableHTTPS = YES;
}

#pragma mark - 检查版本

- (void)fetchAppVersionInfo {
    if (self.updateIsShow) {
        return;
    }
    
    self.updateIsShow = YES;
    [[TCBuluoApi api] fetchAppVersionInfo:^(TCAppVersion *versionInfo, NSError *error) {
        if (versionInfo) {
            [weakSelf checkAppVersionInfo:versionInfo];
        } else {
            weakSelf.updateIsShow = NO;
        }
    }];
}

- (void)checkAppVersionInfo:(TCAppVersion *)versionInfo {
    
    /** 强制更新 */
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *minVersion = versionInfo.minVersion;
    
    NSArray *currentVersionParts = [currentVersion componentsSeparatedByString:@"."];
    NSArray *minVersionParts = [minVersion componentsSeparatedByString:@"."];
    
    if (currentVersionParts.count > 2 && minVersionParts.count > 2) {
        BOOL force = NO;
        for (int i=0; i<3; i++) {
            NSInteger currentVersionPart = [currentVersionParts[i] integerValue];
            NSInteger minVersionPart = [minVersionParts[i] integerValue];
            if (currentVersionPart > minVersionPart) {
                break;
            } else if (currentVersionPart < minVersionPart) {
                force = YES;
                break;
            }
        }
        
        if (force) {
            [self forceUpdateWithVersionInfo:versionInfo];
            return;
        }
    }
    
    
    /** 建议更新 */
    NSString *lastVersion = versionInfo.lastVersion;
    NSString *cachedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeyAppVersion];
    if (cachedVersion == nil) {
        cachedVersion = currentVersion;
    }
    
    NSArray *cachedVersionParts = [cachedVersion componentsSeparatedByString:@"."];
    NSArray *lastVersionParts = [lastVersion componentsSeparatedByString:@"."];
    
    if (cachedVersionParts.count > 1 && lastVersionParts.count > 1) {
        BOOL update = NO;
        for (int i=0; i<2; i++) {
            NSInteger cachedVersionPart = [cachedVersionParts[i] integerValue];
            NSInteger lastVersionPart = [lastVersionParts[i] integerValue];
            if (cachedVersionPart > lastVersionPart) {
                break;
            } else if (cachedVersionPart < lastVersionPart) {
                update = YES;
                break;
            }
        }
        
        if (update) {
            [self updateWithVersionInfo:versionInfo];
            return;
        }
    }
}

- (void)updateWithVersionInfo:(TCAppVersion *)versionInfo {
    NSString *title = @"检查到新版本，是否确认更新？";
    NSString *message = versionInfo.releaseNote.count ? [versionInfo.releaseNote componentsJoinedByString:@"\n"] : nil;
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.updateIsShow = NO;
        [[NSUserDefaults standardUserDefaults] setObject:versionInfo.lastVersion forKey:TCUserDefaultsKeyAppVersion];
    }];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.updateIsShow = NO;
        [[NSUserDefaults standardUserDefaults] setObject:versionInfo.lastVersion forKey:TCUserDefaultsKeyAppVersion];
        NSString *appStoreUrl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TCBuluoAppStoreURL"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }];
    [vc addAction:cancelAction];
    [vc addAction:updateAction];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)forceUpdateWithVersionInfo:(TCAppVersion *)versionInfo {
    UIWindow *updateWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    updateWindow.windowLevel = UIWindowLevelAlert;
    updateWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.37];
    updateWindow.hidden = NO;
    self.updateWindow = updateWindow;
    
    TCForceUpdateView *updateView = [[TCForceUpdateView alloc] initWithVersionInfo:versionInfo];
    updateView.delegate = self;
    [updateWindow addSubview:updateView];
    [updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(updateWindow);
    }];
}

#pragma mark - TCForceUpdateViewDelegate

- (void)didClickUpdateButtonInForceUpdateView:(TCForceUpdateView *)view {
    NSString *appStoreUrl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TCBuluoAppStoreURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
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
