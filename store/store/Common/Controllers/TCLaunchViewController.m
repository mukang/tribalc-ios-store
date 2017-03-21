//
//  TCLaunchViewController.m
//  individual
//
//  Created by 穆康 on 2017/1/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLaunchViewController.h"
#import "TCFunctions.h"

NSString *const TCLaunchWindowDidAppearNotification    = @"TCLaunchWindowDidAppearNotification";
NSString *const TCLaunchWindowDidDisappearNotification = @"TCLaunchWindowDidDisappearNotification";

@interface TCLaunchViewController ()

@property (weak, nonatomic) UIImageView *launchImageView;
@property (weak, nonatomic) UILabel *versionLabel;

@end

@implementation TCLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat screenWidth = TCScreenWidth;
    NSString *launchImageName;
    if (screenWidth == 320) {
        launchImageName = @"HD4.0''";
    } else if (screenWidth == 375) {
        launchImageName = @"HD4.7''";
    } else {
        launchImageName = @"HD5.5''";
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:launchImageName ofType:@".png"];
    UIImage *launchImage = [UIImage imageWithContentsOfFile:filePath];
    
    UIImageView *launchImageView = [[UIImageView alloc] initWithImage:launchImage];
    launchImageView.frame = [UIScreen mainScreen].bounds;
    launchImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:launchImageView];
    self.launchImageView = launchImageView;
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"%@", TCGetAppVersion()];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.font = [UIFont systemFontOfSize:15];
    [versionLabel sizeToFit];
    versionLabel.centerX = TCScreenWidth * 0.5;
    versionLabel.centerY = TCScreenHeight - 50;
    [self.view addSubview:versionLabel];
    self.versionLabel = versionLabel;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCLaunchWindowDidAppearNotification object:nil];
    [self hideAnimated];
}

- (void)hideAnimated {
    __weak typeof(self) weakSelf = self;
    
    CGRect frame = self.launchImageView.frame;
    CGRect frame1 = CGRectInset(frame, -8, -8);
    CGRect frame2 = CGRectInset(frame1, -20, -20);
    
    [UIView animateWithDuration:2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.launchImageView.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.versionLabel.alpha = 0.0;
            weakSelf.launchImageView.alpha = 0.0;
            weakSelf.launchImageView.frame = frame2;
        } completion:^(BOOL finished) {
            weakSelf.launchWindow.hidden = YES;
            weakSelf.launchImageView.alpha = 1.0;
            [[NSNotificationCenter defaultCenter] postNotificationName:TCLaunchWindowDidDisappearNotification object:nil];
        }];
    }];
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
