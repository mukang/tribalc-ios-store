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
#import "TCCommonButton.h"

@interface TCChoseSpecificationsController ()<UITableViewDelegate,UITableViewDataSource,TCGoodsStandardListCellDelegate>

@property (strong, nonatomic) UITableView *tabelView;

@property (strong, nonatomic) TCGoodsStandardWrapper *goodsStandardwrapper;

@property (copy, nonatomic) NSArray *currentArr;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (copy, nonatomic) NSDictionary *goodsStandardDic;

@end

@implementation TCChoseSpecificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商品规格";
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadDataIsMore:NO];
}

- (void)loadDataIsMore:(BOOL)isMore {
    [MBProgressHUD showHUD:YES];
    
    NSString *sortSkip;
    if (isMore) {
        sortSkip = self.goodsStandardwrapper.nextSkip;
    }else {
        sortSkip = nil;
    }
    
    [[TCBuluoApi api] fetchGoodsStandardWarpper:20 category:self.good.category sort:nil sortSkip:sortSkip result:^(TCGoodsStandardWrapper *goodsStandardWrapper, NSError *error) {
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

- (void)didClick:(UITableViewCell *)cell selected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tabelView indexPathForCell:cell];
    if (selected) {
        self.selectedIndexPath = indexPath;
        
        [self getStandardGoods:cell indexPath:indexPath];
        
    }else {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self.tabelView reloadData];
    
}

- (void)getStandardGoods:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexpath{
    
    if (indexpath.section == 0) {
        return;
    }
    
    TCGoodsStandardListCell *standardCell = (TCGoodsStandardListCell *)cell;
    
    TCGoodsStandardMate *standardMeta = self.currentArr[indexpath.section-1];
    
    if ([standardMeta isKindOfClass:[TCGoodsStandardMate class]]) {
        if (self.goodsStandardDic) {
            for (NSString *str in self.goodsStandardDic.allKeys) {
                if ([str isEqualToString:standardMeta.ID]) {
                    TCGoodStandards *standard = self.goodsStandardDic[str];
                    if ([standard isKindOfClass:[TCGoodStandards class]]) {
                        standardCell.goodsStandard = standard;
                    }
                }
            }
        }else {
            [[TCBuluoApi api] fetchGoodStandards:standardMeta.ID result:^(TCGoodStandards *goodStandard, NSError *error) {
                if (goodStandard) {
                    standardCell.goodsStandard = goodStandard;
                    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.goodsStandardDic];
                    [mutableDic setObject:goodStandard forKey:standardMeta.ID];
                    self.goodsStandardDic = mutableDic;
                }
            }];
        }
    }
}

#pragma mark UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.currentArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsStandardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStandardListCell"];
    if (cell == nil) {
        cell = [[TCGoodsStandardListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsStandardListCell"];
        cell.delegate = self;
    }
    if (indexPath.section == 0) {
        TCGoodsStandardMate *goodsStandardMate = [[TCGoodsStandardMate alloc] init];
        goodsStandardMate.title = @"创建新的规格组";
        cell.goodsStandardMate = goodsStandardMate;
        if (_selectedIndexPath.section == 0 && _selectedIndexPath.row == 0) {
            cell.select = YES;
        }else {
            cell.select = NO;
        }
        
    }else {
        
        if (_selectedIndexPath == indexPath) {
            cell.select = YES;
        }else {
            cell.select = NO;
        }
        
        cell.goodsStandardMate = self.currentArr[indexPath.section-1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 45;
    }
    
    TCGoodsStandardMate *goodsStandardMate = (TCGoodsStandardMate *)(self.currentArr[indexPath.section-1]);
    NSString *str = goodsStandardMate.title;
    CGSize size = [str boundingRectWithSize:CGSizeMake(TCScreenWidth-115, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    if (indexPath == _selectedIndexPath && indexPath.section != 0) {
        return size.height+28.0+178.0;
    }
    
    return size.height+28.0;
}



- (void)next {
    
    TCCreateGoodsViewController *createVC = [[TCCreateGoodsViewController alloc] init];
    
    if (self.selectedIndexPath.section != 0) {
        TCGoodsStandardMate *goodsStandardMate = self.currentArr[self.selectedIndexPath.section-1];
        self.good.standardId = goodsStandardMate.ID;
        createVC.currentGoodsStandardMate = goodsStandardMate;
    }
    
    createVC.goods = self.good;
    [self.navigationController pushViewController:createVC animated:YES];
    
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
        
        TCCommonButton *bottomBtn = [TCCommonButton buttonWithTitle:@"下一步" color:TCCommonButtonColorOrange target:self action:@selector(next)];
        [self.view addSubview:bottomBtn];
        
        [_tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(bottomBtn.mas_top);
        }];
        
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.tabelView.mas_bottom);
            make.height.equalTo(@50);
        }];
    }
    return _tabelView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
