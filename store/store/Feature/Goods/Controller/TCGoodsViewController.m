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
#import "TCGoodsMetaWrapper.h"
#import "TCGoodsMeta.h"
#import "TCBuluoApi.h"
#import "TCGoodsListCell.h"
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>
#import "TCCreateGoodsViewController.h"
#import "TCUnCommonView.h"
#import "TCBusinessLicenceViewController.h"
#import "TCLoginViewController.h"
#import "TCNavigationController.h"

@interface TCGoodsViewController ()<UITableViewDelegate, UITableViewDataSource,TCUnCommonViewDelegate>

@property (strong, nonatomic) UIButton *onSaleBtn;

@property (strong, nonatomic) UIButton *storeBtn;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCGoodsMetaWrapper *goodsWrapper;

@property (strong, nonatomic) NSArray *goods;

@property (strong, nonatomic) UIButton *btn;

@property (assign, nonatomic) BOOL first;

@property (strong, nonatomic) TCUnCommonView *unCommonView;

@end

@implementation TCGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.first = YES;
    self.title = @"商品管理";
    [self setUpTopViews];
    [self setCreatBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.first) {
        [self onClick:_onSaleBtn];
    }else {
        [self loadData];
    }
}

- (void)loadData {
    
    if ([[TCBuluoApi api] needLogin]) {
        [_onSaleBtn setTitle:@"出售中" forState:UIControlStateNormal];
        [_storeBtn setTitle:@"仓库中" forState:UIControlStateNormal];
        [self.view bringSubviewToFront:self.unCommonView];
        self.unCommonView.hidden = NO;
        self.unCommonView.unCommonType = TCUnCommonTypeUnLogin;
        self.btn.hidden = YES;
        self.goodsWrapper = nil;
        self.goods = nil;
        [self.tableView reloadData];
        self.tableView.hidden = YES;
        [self headViewInitNumber];
    }else {
        self.unCommonView.hidden = YES;
        self.btn.hidden = NO;
        NSString *authS = [TCBuluoApi api].currentUserSession.storeInfo.authorizedStatus;
        if ([authS isEqualToString:@"SUCCESS"]) {
            [self loadDataIsMore:NO];
        }else {
            @WeakObj(self)
            [MBProgressHUD showHUD:YES];
            [[TCBuluoApi api] fetchStoreAuthenticationInfo:^(TCAuthenticationInfo *authenticationInfo, NSError *error) {
                @StrongObj(self)
                if (authenticationInfo) {
                    [MBProgressHUD hideHUD:YES];
                    
                    NSString *authStr = authenticationInfo.authenticationStatus;
                    if ([authStr isEqualToString:@"SUCCESS"]) {
                        self.unCommonView.hidden = YES;
                        [self loadDataIsMore:NO];
                    }else {
                        [self.view bringSubviewToFront:self.unCommonView];
                        self.unCommonView.hidden = NO;
                        self.unCommonView.unCommonType = TCUnCommonTypeUnCommon;
                        [self.view bringSubviewToFront:self.btn];
                        self.goods = nil;
                        self.goodsWrapper = nil;
                        [self.tableView reloadData];
                        self.tableView.hidden = YES;
                        [self headViewInitNumber];
                    }
                    
                }else {
                    NSString *reason = error.localizedDescription ?: @"请稍后再试";
                    [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
                    [self.view bringSubviewToFront:self.btn];
                    self.goods = nil;
                    self.goodsWrapper = nil;
                    [self.tableView reloadData];
                    self.tableView.hidden = YES;
                    [self headViewInitNumber];
                }
            }];
        }
    }
}

- (void)updateSelf {
    [self loadDataIsMore:NO];
}

- (void)loadDataIsMore:(BOOL)isMore {
    [MBProgressHUD showHUD:YES];
    
    BOOL isPublish = YES;
    
    if (_onSaleBtn.selected) {
        isPublish = YES;
    }else if (_storeBtn.selected) {
        isPublish = NO;
    }
    
    NSString *skip = nil;
    
    if (isMore) {
        skip = self.goodsWrapper.nextSkip;
    }
    @WeakObj(self)
    [[TCBuluoApi api] fetchGoodsWrapper:isPublish limitSize:20 sort:nil sortSkip:skip result:^(TCGoodsMetaWrapper *goodsWrapper, NSError *error) {
        @StrongObj(self)
        if (goodsWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.goodsWrapper = goodsWrapper;
            
            if (self.tableView.hidden) {
                self.tableView.hidden = NO;
            }
            
            if (!goodsWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (isMore) {
                NSMutableArray *mutabelArr = [NSMutableArray arrayWithArray:self.goods];
                [mutabelArr addObjectsFromArray:goodsWrapper.content];
                self.goods = mutabelArr;
                
                [self.tableView.mj_footer endRefreshing];
                
            }else {
                self.goods = goodsWrapper.content;
                [self.onSaleBtn setTitle:[NSString stringWithFormat:@"出售中(%ld)",(long)goodsWrapper.publishedAmount] forState:UIControlStateNormal];
                [self.storeBtn setTitle:[NSString stringWithFormat:@"仓库中(%ld)",(long)goodsWrapper.unpublishedAmount] forState:UIControlStateNormal];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = NO;
            }
            
            [self.tableView reloadData];

            if (self.goods.count == 0) {
                [self.view bringSubviewToFront:self.unCommonView];
                self.unCommonView.unCommonType = TCUnCommonTypeNoContent;
                self.unCommonView.hidden = NO;
            }else {
                [self.view bringSubviewToFront:self.tableView];
                self.unCommonView.hidden = YES;
            }
            
            [self.view bringSubviewToFront:self.btn];
            
        }else {
            if (isMore) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_header endRefreshing];
            }
            
            if ([[TCBuluoApi api] needLogin]) {
                self.goodsWrapper = nil;
                self.goods = nil;
                [self.tableView reloadData];
                self.tableView.hidden = YES;
            }
            
            if (self.tableView.hidden) {
                self.tableView.hidden = NO;
            }
            
            [self.view bringSubviewToFront:self.btn];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
    
}

- (void)headViewInitNumber {
    [self.onSaleBtn setTitle:@"出售中(0)" forState:UIControlStateNormal];
    [self.storeBtn setTitle:@"仓库中(0)" forState:UIControlStateNormal];
}

- (void)setUpTopViews {
    _onSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_onSaleBtn setTitle:@"出售中" forState:UIControlStateNormal];
    [self.view addSubview:_onSaleBtn];
    _onSaleBtn.tag = 1111;
    [_onSaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_onSaleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCGrayColor;
    [_onSaleBtn addSubview:lineView];
    
    _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_storeBtn setTitle:@"仓库中" forState:UIControlStateNormal];
    [self.view addSubview:_storeBtn];
    _storeBtn.tag = 2222;
    [_storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_storeBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_onSaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(@0);
        make.width.equalTo(@(TCScreenWidth/2.0));
        make.height.equalTo(@(TCRealValue(41)));
    }];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2.0 : 3.0;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_onSaleBtn);
        make.right.equalTo(_onSaleBtn);
        make.height.equalTo(@(TCRealValue(20)));
        make.width.equalTo(@(1/scale));
    }];
    
    [_storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_onSaleBtn.mas_right);
        make.top.height.width.equalTo(_onSaleBtn);
    }];
    
}

- (void)setCreatBtn {
    if (_btn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:TCRGBColor(252, 108, 38)];
        btn.layer.cornerRadius = 25;
        [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.view).offset(-20);
            make.width.height.equalTo(@50);
        }];
        
        UIView *h = [[UIView alloc] init];
        h.frame = CGRectMake(0, 0, 20, 3);
        h.centerX = 25;
        h.centerY = 25;
        h.backgroundColor = [UIColor whiteColor];
        h.userInteractionEnabled = NO;
        [btn addSubview:h];
        
        UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 20)];
        l.centerY = 25;
        l.centerX = 25;
        l.backgroundColor = [UIColor whiteColor];
        l.userInteractionEnabled = NO;
        [btn addSubview:l];
        self.btn = btn;
    }
    
}

- (void)onClick:(UIButton *)btn {
    self.first = NO;
    if (btn.tag == 1111) {
        _onSaleBtn.selected = YES;
        _storeBtn.selected = NO;
        [_onSaleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        _storeBtn.selected = YES;
        _onSaleBtn.selected = NO;
        [_onSaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_storeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    
    [self loadData];
}


- (void)setupTableViewRefreshView {
    @WeakObj(self)
    TCRefreshHeader *refreshHeader = [TCRefreshHeader headerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        [self loadDataIsMore:NO];
    }];
    self.tableView.mj_header = refreshHeader;
    
    TCRefreshFooter *refreshFooter = [TCRefreshFooter footerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        if (self.goodsWrapper.hasMore) {
            [self loadDataIsMore:YES];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    refreshFooter.hidden = YES;
    self.tableView.mj_footer = refreshFooter;
}

#pragma mark TCUnCommonViewDelegate

- (void)toAuth {
    TCBusinessLicenceViewController *businessVC = [[TCBusinessLicenceViewController alloc] init];
    businessVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:businessVC animated:YES];
}

- (void)toLogin {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsListCell"];
    if (cell == nil) {
        cell = [[TCGoodsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsListCell"];
    }
    cell.good = self.goods[indexPath.section];
    
    NSString *upStr = @"修改";
    NSString *downStr;
    if (self.onSaleBtn.selected) {
        downStr = @"下架";
    }else if (_storeBtn.selected) {
        downStr = @"删除";
    }
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 95, 150);
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setBackgroundColor:TCRGBColor(248, 160, 66)];
    [topBtn setTitle:upStr forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topBtn.frame = CGRectMake(0, 0, 95, 75);
    [rightBtn addSubview:topBtn];
    topBtn.tag = indexPath.section*100;
    [topBtn addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 74.5, 95, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [topBtn addSubview:lineView];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0, CGRectGetMaxY(topBtn.frame), 95, 75);
    [downBtn setBackgroundColor:TCRGBColor(248, 160, 66)];
    [downBtn setTitle:downStr forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addSubview:downBtn];
    downBtn.tag = indexPath.section*100;
    [downBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.rightButtons = @[rightBtn];
    return cell;
}

#pragma UIButton Event

- (void)modify:(UIButton *)btn {
    
    NSInteger index = btn.tag/100;
    TCGoodsMeta *good = self.goods[index];
    @WeakObj(self)
    if (good.standardId) {
        [[TCBuluoApi api] getGoodsStandard:good.standardId result:^(TCGoodsStandardMate *goodsStandardMate, NSError *error) {
            @StrongObj(self)
            if (goodsStandardMate) {
                TCCreateGoodsViewController *createVc = [[TCCreateGoodsViewController alloc] init];
                createVc.goods = good;
                createVc.currentGoodsStandardMate = goodsStandardMate;
                createVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:createVc animated:YES];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取规格组失败，%@", reason]];
            }
        }];
    }else {
        TCCreateGoodsViewController *createVc = [[TCCreateGoodsViewController alloc] init];
        createVc.goods = good;
        createVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:createVc animated:YES];
    }
}

- (void)delete:(UIButton *)btn {
    NSInteger index = btn.tag/100;
    TCGoodsMeta *good = self.goods[index];
    NSString *goodsID = good.ID;
    
    if (_onSaleBtn.selected) {
        [[TCBuluoApi api] modifyGoodsState:goodsID published:@"false" result:^(BOOL success, NSError *error) {
            if (success) {
                [self loadDataIsMore:NO];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"下架失败，%@", reason]];
            }
        }];
    }else {
        [[TCBuluoApi api] deleteGoods:goodsID result:^(BOOL success, NSError *error) {
            if (success) {
                [self loadDataIsMore:NO];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"删除失败，%@", reason]];
            }
        }];
    }
}

- (void)next {
    
    NSString *storeState = [TCBuluoApi api].currentUserSession.storeInfo.authorizedStatus;
    if ([storeState isEqualToString:@"SUCCESS"]) {
        TCGoodsCategoryController *goodCVC = [[TCGoodsCategoryController alloc] init];
        goodCVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodCVC animated:YES];
    }else {
        if ([[TCBuluoApi api] needLogin]) {
            [MBProgressHUD showHUDWithMessage:@"请先登录并创建商铺"];
        }else {
            [MBProgressHUD showHUDWithMessage:@"请创建商铺并认证"];
        }
        
    }

}

- (TCUnCommonView *)unCommonView {
    if (_unCommonView == nil) {
        _unCommonView = [[TCUnCommonView alloc] init];
        [self.view addSubview:_unCommonView];
        _unCommonView.delegate = self;
        
        [_unCommonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_storeBtn.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _unCommonView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, CGFLOAT_MIN)];
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0.01;
        _tableView.sectionHeaderHeight = 5.0;
        _tableView.rowHeight = 150.0;
        [self.view addSubview:_tableView];
        [self setupTableViewRefreshView];
        
        [self.view bringSubviewToFront:_btn];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_storeBtn.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (void)dealloc {
    TCLog(@"TCGoodsViewController -- dealloc");
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
