//
//  TCOrderViewController.m
//  store
//
//  Created by 穆康 on 2017/1/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderViewController.h"
#import "TCGoodsOrderViewController.h"
#import "TCReservationViewController.h"

@interface TCOrderViewController ()

@end

@implementation TCOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *goodsOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsOrderButton.backgroundColor = TCRGBColor(221, 221, 221);
    [goodsOrderButton setTitle:@"商品订单" forState:UIControlStateNormal];
    [goodsOrderButton addTarget:self action:@selector(handleClickGoodsOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    goodsOrderButton.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:goodsOrderButton];
    
    UIButton *reservationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reservationButton.backgroundColor = TCRGBColor(221, 221, 221);
    [reservationButton setTitle:@"服务预定" forState:UIControlStateNormal];
    [reservationButton addTarget:self action:@selector(handleClickReservationButton:) forControlEvents:UIControlEventTouchUpInside];
    reservationButton.frame = CGRectMake(100, 200, 100, 50);
    [self.view addSubview:reservationButton];
}

- (void)handleClickGoodsOrderButton:(UIButton *)sender {
    TCGoodsOrderViewController *vc = [[TCGoodsOrderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickReservationButton:(UIButton *)sender {
    TCReservationViewController *vc = [[TCReservationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
