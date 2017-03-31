//
//  TCUserAgreementViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserAgreementViewController.h"
#import <TCCommonLibs/UIImage+Category.h>

@interface TCUserAgreementViewController ()

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSMutableAttributedString *userAgreementText;

@end

@implementation TCUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"用户协议";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    };
    UIImage *bgImage = [UIImage imageWithColor:TCBlackColor];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setupSubviews {
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.attributedText = self.userAgreementText;
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.textView];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Override Methods

- (NSMutableAttributedString *)userAgreementText {
    if (nil == _userAgreementText) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"TCUserAgreement" withExtension:@"rtf"];
        if (fileURL) {
            NSError *error = nil;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
                _userAgreementText = [[NSMutableAttributedString alloc] initWithURL:fileURL options:@{} documentAttributes:nil error:&error];
            } else {
                _userAgreementText = [[NSMutableAttributedString alloc] initWithFileURL:fileURL options:@{} documentAttributes:nil error:&error];
            }
            if (error) {
                NSLog(@"user agreement file read error: %@", error);
            }
        }
    }
    return _userAgreementText;
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
