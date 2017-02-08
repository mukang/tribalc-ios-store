//
//  TCGoodsOrderViewController.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderViewController.h"
#import "TCTabView.h"

@interface TCGoodsOrderViewController ()

@end

@implementation TCGoodsOrderViewController {
    __weak TCGoodsOrderViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"订单管理";
    
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCTabView *tabView = [[TCTabView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 40) titleArr:@[@"全部", @"待付款", @"待发货", @"待收货", @"已完成"]];
    tabView.tapBlock = ^(NSInteger index) {
        
    };
    [self.view addSubview:tabView];
    
    
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
