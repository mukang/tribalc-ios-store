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

#import "TCFunctions.h"
#import <EAIntroView/EAIntroView.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static NSString *const kAppVersion = @"kAppVersion";
static NSString *const AMapApiKey = @"f6e6be9c7571a38102e25077d81a960a";

@interface TCTabBarController ()

@end

@implementation TCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    
    [self addChildController:[[TCHomeViewController alloc] init] title:@"首页" image:@"tabBar_home_normal" selectedImage:@"tabBar_home_selected"];
    [self addChildController:[[TCGoodsViewController alloc] init] title:@"商品" image:@"tabBar_goods_normal" selectedImage:@"tabBar_goods_selected"];
    [self addChildController:[[TCOrderViewController alloc] init] title:@"订单" image:@"tabBar_order_normal" selectedImage:@"tabBar_order_selected"];
    [self addChildController:[[TCProfileViewController alloc] init] title:@"店铺" image:@"tabBar_profile_normal" selectedImage:@"tabBar_profile_selected"];
    
    
    [self handleShowIntroView];
    [self setupAMapServices];
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
