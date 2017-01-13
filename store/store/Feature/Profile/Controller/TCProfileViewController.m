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
#import "TCBuluoApi.h"

@interface TCProfileViewController ()

@end

@implementation TCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self checkUserNeedLogin];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
