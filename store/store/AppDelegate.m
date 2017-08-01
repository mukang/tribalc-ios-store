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

#import <SDImageCache.h>
#import <SDImageCacheConfig.h>

static NSString *const kBuglyAppID = @"9ed163958b";

@interface AppDelegate ()<CLLocationManagerDelegate>

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
    
    // 设置图片缓存时间
    [SDImageCache sharedImageCache].config.maxCacheAge = 60 * 60 * 24;
    
    [self showLaunchWindow];
    application.statusBarHidden = NO;
    
    // 获取应用初始化信息
    [self setupAppInitializedInfo];
    
    // Bugly
    [Bugly startWithAppId:kBuglyAppID];
    
    [self startLocationAction];
    
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

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLaunchWindowDidDisappear)
                                                 name:TCLaunchWindowDidDisappearNotification object:nil];
}

#pragma mark - Actions

- (void)handleLaunchWindowDidDisappear {
    self.launchWindow.rootViewController = nil;
    self.launchWindow = nil;
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
