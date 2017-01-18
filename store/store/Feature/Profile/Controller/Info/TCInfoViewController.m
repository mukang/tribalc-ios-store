//
//  TCInfoViewController.m
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCInfoViewController.h"
#import "TCInfoEditViewController.h"

#import "TCInfoViewCell.h"

#import <Masonry.h>
#import "TCBuluoApi.h"

@interface TCInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCInfoViewController {
    __weak TCInfoViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"店铺信息";
    
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 49;
    [tableView registerClass:[TCInfoViewCell class] forCellReuseIdentifier:@"TCInfoViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCInfoViewCell" forIndexPath:indexPath];
    TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"店铺名称";
            cell.subtitleLabel.text = storeInfo.name;
            break;
        case 1:
            cell.titleLabel.text = @"联系人姓名";
            cell.subtitleLabel.text = storeInfo.linkman;
            break;
        case 2:
            cell.titleLabel.text = @"联系人手机";
            cell.subtitleLabel.text = storeInfo.phone;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
    switch (indexPath.row) {
        case 0:
        {
            TCInfoEditViewController *vc = [[TCInfoEditViewController alloc] initWithEditType:TCInfoEditTypeName];
            vc.name = storeInfo.name;
            vc.editBlock = ^() {
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            TCInfoEditViewController *vc = [[TCInfoEditViewController alloc] initWithEditType:TCInfoEditTypeLinkman];
            vc.linkman = storeInfo.linkman;
            vc.editBlock = ^() {
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
