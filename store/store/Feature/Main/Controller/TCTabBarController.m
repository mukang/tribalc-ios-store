//
//  TCTabBarController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTabBarController.h"
#import "TCNavigationController.h"
//#import "TCProfileViewController.h"
//#import "TCVicinityViewController.h"
//#import "TCHomeViewController.h"
//#import "TCCommunitiesViewController.h"
//#import "TCToolsViewController.h"

#import "TCTabBar.h"
//#import "TCFunctions.h"
//#import <EAIntroView/EAIntroView.h>

static NSString *const kAppVersion = @"kAppVersion";

@interface TCTabBarController ()

@end

@implementation TCTabBarController
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildController:[[TCHomeViewController alloc] init] title:@"首页" image:@"tabBar_home_normal" selectedImage:@"tabBar_home_selected"];
    [self addChildController:[[TCCommunitiesViewController alloc] init] title:@"社区" image:@"tabBar_discover_normal" selectedImage:@"tabBar_discover_selected"];
    [self addChildController:[[TCToolsViewController alloc] init] title:@"常用" image:@"tabBar_common_normal" selectedImage:@"tabBar_common_selected"];
    [self addChildController:[[TCProfileViewController alloc] init] title:@"我的" image:@"tabBar_profile_normal" selectedImage:@"tabBar_profile_selected"];
    
    [self setValue:[[TCTabBar alloc] init] forKey:@"tabBar"];
    
    [self registerNotifications];
    
    [self handleShowIntroView];
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
    if ([title isEqualToString:@"附近"]) {
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
    }
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    [self addChildViewController:nav];
}

#pragma mark - notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClickVicinityButton:) name:TCVicinityButtonDidClickNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - actions

- (void)handleClickVicinityButton:(NSNotification *)noti {
    TCVicinityViewController *vicinityVC = [[TCVicinityViewController alloc] init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vicinityVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}
 */

#pragma mark - Intro View

/**
 判断是否要显示引导页
 */
//- (void)handleShowIntroView {
//    if (![self isFirstLaunch]) return;
//    
//    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:3];
//    for (int i=0; i<3; i++) {
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"intro_image_%02zd", i+1] ofType:@"png"];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
//        EAIntroPage *introPage = [EAIntroPage pageWithCustomView:imageView];
//        [tempArray addObject:introPage];
//    }
//    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:tempArray];
//    introView.skipButton.hidden = YES;
//    introView.pageControl.hidden = YES;
//    introView.scrollView.bounces = NO;
//    [introView showInView:self.view animateDuration:0];
//}
//
//- (BOOL)isFirstLaunch {
//    NSString *appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
//    NSString *currentAppVersion = TCGetAppVersion();
//    if (appVersion == nil || ![appVersion isEqualToString:currentAppVersion]) {
//        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        return YES;
//    } else {
//        return NO;
//    }
//}

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
