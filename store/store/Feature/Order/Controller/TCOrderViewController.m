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
#import "TCLoginViewController.h"
#import "TCNavigationController.h"

#import "TCExtendButton.h"

#import "TCBuluoApi.h"

@interface TCOrderViewController ()

@property (weak, nonatomic) UIImageView *bgImageView;
@property (weak, nonatomic) TCExtendButton *goodsOrderButton;
@property (weak, nonatomic) UILabel *goodsOrderLabel;
@property (weak, nonatomic) TCExtendButton *reservationButton;
@property (weak, nonatomic) UILabel *reservationLabel;

@end

@implementation TCOrderViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupSubviews {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"order_background" ofType:@"png"]];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    TCExtendButton *goodsOrderButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [goodsOrderButton setImage:[UIImage imageNamed:@"order_goods"] forState:UIControlStateNormal];
    [goodsOrderButton addTarget:self action:@selector(handleClickGoodsOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodsOrderButton];
    self.goodsOrderButton = goodsOrderButton;
    
    UILabel *goodsOrderLabel = [[UILabel alloc] init];
    goodsOrderLabel.text = @"订单管理";
    goodsOrderLabel.textColor = TCRGBColor(42, 42, 42);
    goodsOrderLabel.textAlignment = NSTextAlignmentCenter;
    goodsOrderLabel.font = [UIFont systemFontOfSize:TCRealValue(16)];
    [self.view addSubview:goodsOrderLabel];
    self.goodsOrderLabel = goodsOrderLabel;
    
    TCExtendButton *reservationButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [reservationButton setImage:[UIImage imageNamed:@"order_reservation"] forState:UIControlStateNormal];
    [reservationButton addTarget:self action:@selector(handleClickReservationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reservationButton];
    self.reservationButton = reservationButton;
    
    UILabel *reservationLabel = [[UILabel alloc] init];
    reservationLabel.text = @"预定管理";
    reservationLabel.textColor = TCRGBColor(42, 42, 42);
    reservationLabel.textAlignment = NSTextAlignmentCenter;
    reservationLabel.font = [UIFont systemFontOfSize:TCRealValue(16)];
    [self.view addSubview:reservationLabel];
    self.reservationLabel = reservationLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
    [self.goodsOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(84), TCRealValue(72)));
        make.top.equalTo(weakSelf.view).offset(TCRealValue(264));
        make.left.equalTo(weakSelf.view).offset(TCRealValue(59.5));
    }];
    [self.goodsOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.goodsOrderButton.mas_bottom).offset(TCRealValue(10));
        make.centerX.equalTo(weakSelf.goodsOrderButton);
    }];
    [self.reservationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(weakSelf.goodsOrderButton);
        make.right.equalTo(weakSelf.view).offset(TCRealValue(-59.5));
    }];
    [self.reservationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.reservationButton.mas_bottom).offset(TCRealValue(10));
        make.centerX.equalTo(weakSelf.reservationButton);
    }];
}

#pragma mark - Actions

- (void)handleClickGoodsOrderButton:(UIButton *)sender {
    if ([self checkUserNeedLogin]) return;
    
    TCGoodsOrderViewController *vc = [[TCGoodsOrderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickReservationButton:(UIButton *)sender {
    if ([self checkUserNeedLogin]) return;
    
    TCReservationViewController *vc = [[TCReservationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
