//
//  TCCreateGoodsStoreViewController.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsStoreViewController.h"

@interface TCCreateGoodsStoreViewController ()

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCCreateGoodsStoreViewController {
    __weak TCCreateGoodsStoreViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.weakSelf = self;
    weakSelf = self;
    self.navigationItem.title = @"创建商铺";
    
//    [self setupSubviews];
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
