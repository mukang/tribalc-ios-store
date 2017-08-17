//
//  AppDelegate.m
//  store
//
//  Created by 穆康 on 2017/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "TCTabBarController.h"
#import "TCLaunchViewController.h"
#import "TCNavigationController.h"
#import "TCUnitySetUpViewController.h"

#import "TCBuluoApi.h"
#import "TCPromotionsManager.h"
#import "TCUserDefaultsKeys.h"
#import "TCLoginViewController.h"
#import "TCNavigationController.h"

#import <CoreLocation/CoreLocation.h>

#import <Bugly/Bugly.h>

#import "TCForceUpdateView.h"

#import "TCUserDefaultsKeys.h"

#import <TCCommonLibs/TCFunctions.h>
#import <EAIntroView/EAIntroView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static NSString *const kAppVersion = @"kAppVersion";
static NSString *const AMapApiKey = @"f6e6be9c7571a38102e25077d81a960a";
static NSString *const kBuglyAppID = @"9ed163958b";

@interface AppDelegate ()<CLLocationManagerDelegate,TCForceUpdateViewDelegate>

@property (strong, nonatomic) UIWindow *updateWindow;
/** 已经显示更新UI，防止重复显示 */
@property (nonatomic) BOOL updateIsShow;

@end

@implementation AppDelegate{
    CLLocationManager *_locationManager;
    BOOL _isRequest;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    TCTabBarController *tabBarController = [[TCTabBarController alloc] init];
//    self.window.rootViewController = tabBarController;
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self showLaunchWindow];
    application.statusBarHidden = NO;
    
    // 获取应用初始化信息
    [self setupAppInitializedInfo];
    
    // Bugly
    [Bugly startWithAppId:kBuglyAppID];
    
    [self startLocationAction];
    
    [self registerNotifications];
    
    [self handleShowIntroView];
    
    [self setupAMapServices];
    
    return YES;
}

#pragma mark - 定位相关

- (void)startLocationAction
{
    _locationManager = [[CLLocationManager alloc] init];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled] &&
        (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
         && !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))) {
            //定位功能可用，开始定位
            _locationManager.delegate=self;
            //设置定位精度
            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            
            [_locationManager stopUpdatingLocation];
            [_locationManager startUpdatingLocation];
            
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:TCUserDefaultsKeyAllowLocal];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:TCUserDefaultsKeyAllowLocal];
        }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:TCUserDefaultsKeyAllowLocal];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:TCUserDefaultsKeyAllowLocal];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (!_isRequest) {
        CLLocation *location=[locations lastObject];//取出第一个位置
        CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
        
        _isRequest = YES;
        [_locationManager stopUpdatingLocation];
        
        [[NSUserDefaults standardUserDefaults] setObject:@[@(coordinate.latitude), @(coordinate.longitude)] forKey:TCBuluoUserLocationCoordinateKey];
        
    }
    
}

#pragma mark - 启动视窗相关

/** 显示启动视窗 */
- (void)showLaunchWindow {
    TCLaunchViewController *launchViewController = [[TCLaunchViewController alloc] init];
    self.launchWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.launchWindow.rootViewController = launchViewController;
    self.launchWindow.windowLevel = UIWindowLevelAlert;
    self.launchWindow.hidden = NO;
    launchViewController.launchWindow = self.launchWindow;
}

#pragma mark - 初始化信息

- (void)setupAppInitializedInfo {
    [[TCBuluoApi api] fetchAppInitializationInfo:^(TCAppInitializationInfo *info, NSError *error) {
        if (info.promotions) {
            [[TCPromotionsManager sharedManager] storePromotionsAndLoadImageWithPromotions:info.promotions];
        }
        if (info.switches) {
            BOOL recharge = YES, withdraw = YES;
            recharge = info.switches.bf_recharge;
            withdraw = info.switches.bf_withdraw;
            [[NSUserDefaults standardUserDefaults] setObject:@(recharge) forKey:TCUserDefaultsKeySwitchBfRecharge];
            [[NSUserDefaults standardUserDefaults] setObject:@(withdraw) forKey:TCUserDefaultsKeySwitchBfWithdraw];
        }
    }];
}

#pragma mark - Actions

- (void)handleLaunchWindowDidDisappear {
    self.launchWindow.rootViewController = nil;
    self.launchWindow = nil;
}

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLaunchWindowDidDisappear)
                                                 name:TCLaunchWindowDidDisappearNotification object:nil];
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
        [self handleUserLogout];
    }];
    [alertController addAction:action];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)handleUserLogout {
    @WeakObj(self)
    [[TCBuluoApi api] logout:^(BOOL success, NSError *error) {
        @StrongObj(self)
        [self showLoginViewController];
    }];
}

#pragma mark - Show Login View Controller

- (void)showLoginViewController {
//    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
//    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    TCNavigationController *nav = (TCNavigationController *)self.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        EAIntroPage *introPage = [EAIntroPage pageWithCustomView:imageView];
        [tempArray addObject:introPage];
    }
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:tempArray];
    introView.skipButton.hidden = YES;
    introView.pageControl.hidden = YES;
    introView.scrollView.bounces = NO;
    [introView showInView:self.window animateDuration:0];
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
    @WeakObj(self)
    [[TCBuluoApi api] fetchAppVersionInfo:^(TCAppVersion *versionInfo, NSError *error) {
        @StrongObj(self)
        if (versionInfo) {
            [self checkAppVersionInfo:versionInfo];
        } else {
            self.updateIsShow = NO;
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
        self.updateIsShow = NO;
        [[NSUserDefaults standardUserDefaults] setObject:versionInfo.lastVersion forKey:TCUserDefaultsKeyAppVersion];
    }];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.updateIsShow = NO;
        [[NSUserDefaults standardUserDefaults] setObject:versionInfo.lastVersion forKey:TCUserDefaultsKeyAppVersion];
        NSString *appStoreUrl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TCBuluoAppStoreURL"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }];
    [vc addAction:cancelAction];
    [vc addAction:updateAction];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
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



#pragma mark - 其它代理方法

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"buluostore"]) {
        [self pushUnitySetUpViewController];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.absoluteString hasPrefix:@"buluostore"]) {
        [self pushUnitySetUpViewController];
        return YES;
    }
    
    return NO;
}

- (void)pushUnitySetUpViewController {
    TCUnitySetUpViewController *setUpVC = [[TCUnitySetUpViewController alloc] init];
    setUpVC.hidesBottomBarWhenPushed = YES;
    TCTabBarController *tabVC = (TCTabBarController *)self.window.rootViewController;
    TCNavigationController *navVC = tabVC.selectedViewController;
    if (navVC) {
        [navVC pushViewController:setUpVC animated:YES];
    }
}

@end
