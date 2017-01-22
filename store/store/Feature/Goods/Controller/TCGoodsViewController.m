//
//  TCGoodsViewController.m
//  store
//
//  Created by 穆康 on 2017/1/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsViewController.h"
#import <Masonry.h>
#import "TCGoodsCategoryController.h"
#import "TCGoodsWrapper.h"
#import "TCGoods.h"

@interface TCGoodsViewController ()

@property (strong, nonatomic) UIButton *onSaleBtn;

@property (strong, nonatomic) UIButton *storeBtn;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCGoodsWrapper *goodsWrapper;

@property (strong, nonatomic) NSArray *goods;

@end

@implementation TCGoodsViewController {
    __weak TCGoodsViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setUpTopViews];
}

- (void)loadDataIsMore:(BOOL)isMore {
    [MBProgressHUD showHUD:YES];
    
    
    
}

- (void)setUpTopViews {
    _onSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_onSaleBtn setTitle:@"出售中" forState:UIControlStateNormal];
    [self.view addSubview:_onSaleBtn];
    _onSaleBtn.tag = 1111;
    [_onSaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_onSaleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(154, 154, 154);
    [_onSaleBtn addSubview:lineView];
    
    _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_storeBtn setTitle:@"仓库中" forState:UIControlStateNormal];
    [self.view addSubview:_storeBtn];
    _storeBtn.tag = 2222;
    [_storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_storeBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.sectionHeaderHeight = 5.0;
//    _tableView.sectionFooterHeight = 0.0;
//    [self.view addSubview:_tableView];
    
    [_onSaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(@0);
        make.width.equalTo(@(TCScreenWidth/2.0));
        make.height.equalTo(@(TCRealValue(41)));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_onSaleBtn);
        make.right.equalTo(_onSaleBtn);
        make.height.equalTo(@(TCRealValue(20)));
        make.width.equalTo(@0.5);
    }];
    
    [_storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_onSaleBtn.mas_right);
        make.top.height.width.equalTo(_onSaleBtn);
    }];
    
    [self onClick:_onSaleBtn];
}

- (void)onClick:(UIButton *)btn {
    if (btn.tag == 1111) {
        [_onSaleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        [_onSaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
}

- (void)next {
    TCGoodsCategoryController *goodCVC = [[TCGoodsCategoryController alloc] init];
    goodCVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodCVC animated:YES];
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
