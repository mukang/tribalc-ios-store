//
//  TCChoseSpecificationsController.m
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCChoseSpecificationsController.h"
#import "TCBuluoApi.h"
#import "TCGoodsStandardListCell.h"
#import "TCGoodsStandardMate.h"
#import "TCCreateGoodsViewController.h"

@interface TCChoseSpecificationsController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tabelView;

@property (strong, nonatomic) TCGoodsStandardWrapper *goodsStandardwrapper;

@property (copy, nonatomic) NSArray *currentArr;

@end

@implementation TCChoseSpecificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商品规格";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"创建商品" style:UIBarButtonItemStyleDone target:self action:@selector(createGoods)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self loadDataIsMore:NO];
}

- (void)createGoods {
    TCCreateGoodsViewController *createVC = [[TCCreateGoodsViewController alloc] init];
    createVC.goods = self.good;
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)loadDataIsMore:(BOOL)isMore {
    [MBProgressHUD showHUD:YES];
    
    NSString *sortSkip;
    if (isMore) {
        sortSkip = self.goodsStandardwrapper.nextSkip;
    }else {
        sortSkip = nil;
    }
    
    [[TCBuluoApi api] fetchGoodsStandardWarpper:20 sort:nil sortSkip:sortSkip result:^(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error) {
        if (goodsStandardWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.goodsStandardwrapper = goodsStandardWrapper;
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.currentArr];
            [mutableArr addObjectsFromArray:goodsStandardWrapper.content];
            self.currentArr = mutableArr;
            [self.tabelView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.currentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsStandardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStandardListCell"];
    if (cell == nil) {
        cell = [[TCGoodsStandardListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsStandardListCell"];
        cell.goodsStandardMate = self.currentArr[indexPath.section];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsStandardMate *goodsStandardMate = (TCGoodsStandardMate *)(self.currentArr[indexPath.section]);
    NSString *str = goodsStandardMate.title;
    CGSize size = [str boundingRectWithSize:CGSizeMake(TCScreenWidth-115, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return size.height+28.0;
}

- (UITableView *)tabelView {
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, CGFLOAT_MIN)];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.sectionHeaderHeight = 9.0;
        _tabelView.sectionFooterHeight = 0.0;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tabelView];
        [_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tabelView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
