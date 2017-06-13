//
//  TCLaunchViewController.m
//  individual
//
//  Created by 穆康 on 2017/1/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLaunchViewController.h"
#import "TCPromotionsManager.h"

NSString *const TCLaunchWindowDidAppearNotification    = @"TCLaunchWindowDidAppearNotification";
NSString *const TCLaunchWindowDidDisappearNotification = @"TCLaunchWindowDidDisappearNotification";
NSString *const TCLaunchWindowDidTapAdViewNotification = @"TCLaunchWindowDidTapAdViewNotification";

@interface TCLaunchViewController ()

@property (weak, nonatomic) UIImageView *launchImageView;

@property (weak, nonatomic) UIImageView *adImageView;
@property (weak, nonatomic) UIButton *countButton;
@property (strong, nonatomic) NSTimer *countTimer;
@property (nonatomic) NSInteger count;
@property (nonatomic) BOOL canSkip;

@end

@implementation TCLaunchViewController {
    __weak TCLaunchViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    TCPromotionsManager *promotionsManager = [TCPromotionsManager sharedManager];
    [promotionsManager queryPromotionsAndImage:^(TCPromotions * _Nullable promotions, UIImage * _Nullable image) {
        if (promotions && image) {
            [weakSelf showAdImageViewWithPromotions:promotions andImage:image];
        } else {
            [weakSelf showNormalImageView];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCLaunchWindowDidAppearNotification object:nil];
    
    if (self.launchImageView) {
        [self hideAnimated];
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Private Methods

- (void)showNormalImageView {
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
}

- (void)showAdImageViewWithPromotions:(TCPromotions *)promotions andImage:(UIImage *)image {
    UIImageView *adImageView = [[UIImageView alloc] initWithImage:image];
    adImageView.frame = [UIScreen mainScreen].bounds;
    adImageView.userInteractionEnabled = YES;
    adImageView.contentMode = UIViewContentModeScaleAspectFill;
    adImageView.clipsToBounds = YES;
    [self.view addSubview:adImageView];
    self.adImageView = adImageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAdImageView:)];
    [adImageView addGestureRecognizer:tap];
    
    UIButton *countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    countButton.frame = CGRectMake(TCScreenWidth - 84, 30, 60, 30);
    [countButton addTarget:self action:@selector(hideAdAnimated) forControlEvents:UIControlEventTouchUpInside];
    countButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    countButton.backgroundColor = TCRGBColor(38, 38, 38);
    countButton.layer.cornerRadius = 4;
    countButton.enabled = promotions.canSkip;
    [self.view addSubview:countButton];
    self.countButton = countButton;
    
    [self startCountDownWithPromotions:promotions];
}

- (void)hideAnimated {
    
    CGRect frame = self.launchImageView.frame;
    CGRect frame1 = CGRectInset(frame, -8, -8);
    CGRect frame2 = CGRectInset(frame1, -20, -20);
    
    [UIView animateWithDuration:2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.launchImageView.frame = frame1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.launchImageView.alpha = 0.0;
            weakSelf.launchImageView.frame = frame2;
        } completion:^(BOOL finished) {
            weakSelf.launchWindow.hidden = YES;
            weakSelf.launchImageView.alpha = 1.0;
            [[NSNotificationCenter defaultCenter] postNotificationName:TCLaunchWindowDidDisappearNotification object:nil];
        }];
    }];
}

- (void)hideAdAnimated {
    
    [self removeCountTimer];
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.adImageView.alpha = 0.0;
        weakSelf.countButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.launchWindow.hidden = YES;
        weakSelf.adImageView.alpha = 1.0;
        weakSelf.countButton.alpha = 1.0;
        [[NSNotificationCenter defaultCenter] postNotificationName:TCLaunchWindowDidDisappearNotification object:nil];
    }];
}

#pragma mark - Timer

- (void)startCountDownWithPromotions:(TCPromotions *)promotions {
    self.count = promotions.skipSeconds;
    self.canSkip = promotions.canSkip;
    
    NSString *str = nil;
    if (promotions.canSkip) {
        str = [NSString stringWithFormat:@"跳过%zd", promotions.skipSeconds];
    } else {
        str = [NSString stringWithFormat:@"%zd", promotions.skipSeconds];
    }
    [self.countButton setTitle:str forState:UIControlStateNormal];
    
    [self addCountTimer];
}

- (void)addCountTimer {
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)removeCountTimer {
    [self.countTimer invalidate];
    self.countTimer = nil;
}

- (void)countDown {
    self.count --;
    if (self.count <= 0) {
        [self removeCountTimer];
        [self hideAdAnimated];
        return;
    }
    
    NSString *str = nil;
    if (self.canSkip) {
        str = [NSString stringWithFormat:@"跳过%zd", self.count];
    } else {
        str = [NSString stringWithFormat:@"%zd", self.count];
    }
    [self.countButton setTitle:str forState:UIControlStateNormal];
}

#pragma mark - Override Methods

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - Actions

- (void)handleTapAdImageView:(UITapGestureRecognizer *)sender {
//    [self removeCountTimer];
//    [self hideAdAnimated];
    
    NSLog(@"点击了广告图");
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
