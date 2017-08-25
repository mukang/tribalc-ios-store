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
#import "TCForceUpdateView.h"
#import "TCUserDefaultsKeys.h"
#import "TCWalletBillDetailViewController.h"
#import "TCGoodsOrderDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <Bugly/Bugly.h>
#import <TCCommonLibs/TCFunctions.h>
#import <EAIntroView/EAIntroView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XGPush.h"
#import "XGSetting.h"
#import "WXApiManager.h"

static NSString *const kAppVersion = @"kAppVersion";
static NSString *const AMapApiKey = @"f6e6be9c7571a38102e25077d81a960a";
static NSString *const kBuglyAppID = @"9ed163958b";

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface AppDelegate () <CLLocationManagerDelegate,TCForceUpdateViewDelegate>

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
    
    // wechat
    [WXApi registerApp:kWXAppID];
    
    // Bugly
    [Bugly startWithAppId:kBuglyAppID];
    
    [self startLocationAction];
    
    [self registerNotifications];
    
    [self handleShowIntroView];
    
    [self setupAMapServices];
    
    if (![[TCBuluoApi api] needLogin]) {
        [self setUpPush:launchOptions];
    }
    
    return YES;
}

#pragma mark - 推送

- (void)setUpAPNS {
    [[XGSetting getInstance] enableDebug:YES];
    [XGPush startApp:2200265540 appKey:@"IJ3Z6631AHGT"];
    [self registerAPNS];
    //获取未读推送消息数
    [self loadUnReadPushNumber];
}

- (void)deleteAPNS {
    [XGPush unRegisterDevice:^{
        NSLog(@"XGPush unRegister success");
    } errorCallback:^{
        NSLog(@"XGPush unRegister fail");
    }];
}

- (void)setUpPush:(NSDictionary *)launchOptions {
    
    [[XGSetting getInstance] enableDebug:YES];
    [XGPush startApp:2200265540 appKey:@"IJ3Z6631AHGT"];
    [self registerAPNS];
    
    [XGPush isPushOn:^(BOOL isPushOn) {
        NSLog(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
    }];
    
    [XGPush handleLaunching:launchOptions successCallback:^{
        NSLog(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        NSLog(@"[XGDemo] Handle launching error");
    }];
}

- (void)handlePushMessage:(NSDictionary *)userInfo {
    if ([[TCBuluoApi api] needLogin]) {
        return;
    }
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *messageDic = userInfo[@"message"];
        if ([messageDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *typeDic = messageDic[@"messageBodyType"];
            if ([typeDic isKindOfClass:[NSDictionary class]]) {
                NSString *type = typeDic[@"name"];
                if ([type isKindOfClass:[NSString class]]) {
                    NSString *referenceId = messageDic[@"referenceId"];
                    // 待发货
                    if ([type isEqualToString:@"ORDER_SETTLE"]) {
                        if ([referenceId isKindOfClass:[NSString class]]) {
                            [self toOrderDetailWithReferenceId:referenceId];
                        }
                    }else if ([type isEqualToString:@"TENANT_WITHDRAW"]) {  // 提现
                        if ([referenceId isKindOfClass:[NSString class]]) {
                            [self toWithDrawDetailWithReferenceId:referenceId];
                        }
                    }
                }
            }
        }
    }
}

- (void)toOrderDetailWithReferenceId:(NSString *)referenceId {
    [[TCBuluoApi api] fetchOrderDetailWithOrderID:referenceId result:^(TCGoodsOrder *order, NSError *error) {
        if (order) {
            TCGoodsOrderDetailViewController *vc = [[TCGoodsOrderDetailViewController alloc] init];
            vc.goodsOrder = order;
            TCNavigationController *nav = (TCNavigationController *)self.window.rootViewController;
            [nav pushViewController:vc animated:YES];
        }
    }];
}

- (void)toWithDrawDetailWithReferenceId:(NSString *)referenceId {
    [[TCBuluoApi api] fetchWithDrawRequestDetailWithRequestId:referenceId result:^(TCWithDrawRequest *withDrawRequest, NSError *error) {
        if ([withDrawRequest isKindOfClass:[TCWithDrawRequest class]]) {
            TCWalletBillDetailViewController *vc = [[TCWalletBillDetailViewController alloc] initWithNibName:@"TCWalletBillDetailViewController" bundle:[NSBundle mainBundle]];
            vc.isWithDraw = YES;
            vc.withDrawRequest = withDrawRequest;
            TCNavigationController *nav = (TCNavigationController *)self.window.rootViewController;
            [nav pushViewController:vc animated:YES];
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:[TCBuluoApi api].currentUserSession.assigned successCallback:^{
        NSLog(@"XGPush register push success");
    } errorCallback:^{
        NSLog(@"XGPush register push error");
    }];
    NSLog(@"XGPush device token is %@", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"XGPush register APNS fail.\n XGPush reason : %@", error);
}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"[XGDemo] receive Notification");
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          [self handlePushMessage:userInfo];
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
}




/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          [self loadUnReadPushNumber];
//                          [self handlePushMessage:userInfo];
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    [self loadUnReadPushNumber];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"[XGDemo] click notification");
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          [self handlePushMessage:response.notification.request.content.userInfo];
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self loadUnReadPushNumber];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    } else {
        // before iOS 8
//        [self registerPushBefore8];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
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

- (void)loadUnReadPushNumber {
    if (![[TCBuluoApi api] needLogin]) {
        [[TCBuluoApi api] fetchUnReadPushMessageNumberWithResult:^(NSDictionary *unreadNumDic, NSError *error) {
            if ([unreadNumDic isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TCFetchUnReadMessageNumber" object:nil userInfo:unreadNumDic];
            }
        }];
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpAPNS) name:TCBuluoApiNotificationUserDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteAPNS) name:TCBuluoApiNotificationUserDidLogout object:nil];
    
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
    [self loadUnReadPushNumber];
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
    TCNavigationController *navVC = (TCNavigationController *)self.window.rootViewController;
    if (navVC) {
        [navVC pushViewController:setUpVC animated:YES];
    }
}

@end
