//
//  TCStoreCategoryViewController.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreCategoryViewController.h"
#import "TCCreateStoreViewController.h"
#import "TCCreateGoodsStoreViewController.h"

#import "TCStoreCategoryViewCell.h"
#import "TCStoreCategoryInfo.h"
#import "NSObject+TCModel.h"

@interface TCStoreCategoryViewController () <UITableViewDataSource, UITableViewDelegate, TCStoreCategoryViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *goodsCategoryInfoArray;
@property (copy, nonatomic) NSArray *serviceCategoryInfoArray;

@end

@implementation TCStoreCategoryViewController {
    __weak TCStoreCategoryViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"选择种类";
    
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.rowHeight = TCRealValue(242);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCStoreCategoryViewCell class] forCellReuseIdentifier:@"TCStoreCategoryViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreCategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreCategoryViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.titleImageView.image = [UIImage imageNamed:@"category_goods"];
        cell.titleLabel.text = @"商品";
        cell.categoryInfoArray = self.goodsCategoryInfoArray;
    } else {
        cell.titleImageView.image = [UIImage imageNamed:@"category_service"];
        cell.titleLabel.text = @"服务";
        cell.categoryInfoArray = self.serviceCategoryInfoArray;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 9;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - TCStoreCategoryViewCellDelegate

- (void)storeCategoryViewCell:(TCStoreCategoryViewCell *)cell didSelectItemWithCategoryInfo:(TCStoreCategoryInfo *)categoryInfo {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        TCLog(@"点击了商品种类");
        TCCreateGoodsStoreViewController *vc = [[TCCreateGoodsStoreViewController alloc] init];
        vc.categoryInfo = categoryInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TCCreateStoreViewController *vc = [[TCCreateStoreViewController alloc] init];
        vc.categoryInfo = categoryInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Override Methods

- (NSArray *)goodsCategoryInfoArray {
    if (_goodsCategoryInfoArray == nil) {
        NSArray *array = @[
                           @{@"name": @"美食", @"icon": @"category_food", @"category": @"FOOD"},
                           @{@"name": @"礼品", @"icon": @"category_gift", @"category": @"GIFT"},
                           @{@"name": @"办公用品", @"icon": @"category_office", @"category": @"OFFICE"},
                           @{@"name": @"生活用品", @"icon": @"category_living", @"category": @"LIVING"},
                           @{@"name": @"家具用品", @"icon": @"category_house", @"category": @"HOUSE"},
                           @{@"name": @"个护化妆", @"icon": @"category_makeup", @"category": @"MAKEUP"},
                           @{@"name": @"妇婴用品", @"icon": @"category_penetration", @"category": @"PENETRATION"}
                           ];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreCategoryInfo *categoryInfo = [[TCStoreCategoryInfo alloc] initWithObjectDictionary:dic];
            [temp addObject:categoryInfo];
        }
        _goodsCategoryInfoArray = [NSArray arrayWithArray:temp];
    }
    return _goodsCategoryInfoArray;
}

- (NSArray *)serviceCategoryInfoArray {
    if (_serviceCategoryInfoArray == nil) {
        NSArray *array = @[
                           @{@"name": @"餐饮", @"icon": @"category_repast", @"category": @"REPAST"},
                           @{@"name": @"美容", @"icon": @"category_hairdressing", @"category": @"HAIRDRESSING"},
                           @{@"name": @"健身", @"icon": @"category_fitness", @"category": @"FITNESS"},
                           @{@"name": @"休闲娱乐", @"icon": @"category_entertainment", @"category": @"ENTERTAINMENT"},
                           @{@"name": @"养生", @"icon": @"category_keephealthy", @"category": @"KEEPHEALTHY"}
                           ];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreCategoryInfo *categoryInfo = [[TCStoreCategoryInfo alloc] initWithObjectDictionary:dic];
            [temp addObject:categoryInfo];
        }
        _serviceCategoryInfoArray = [NSArray arrayWithArray:temp];
    }
    return _serviceCategoryInfoArray;
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
