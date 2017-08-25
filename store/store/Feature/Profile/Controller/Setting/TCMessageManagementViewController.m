//
//  TCMessageManagementViewController.m
//  individual
//
//  Created by 穆康 on 2017/8/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMessageManagementViewController.h"

#import "TCMessageManagementViewCell.h"

#import "TCBuluoApi.h"

@interface TCMessageManagementViewController () <UITableViewDataSource, UITableViewDelegate, TCMessageManagementViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *messageManagementList;

@end

@implementation TCMessageManagementViewController {
    __weak TCMessageManagementViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"消息管理";
    
    [self setupSubviews];
    [self loadNetData];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 54;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMessageManagementViewCell class] forCellReuseIdentifier:@"TCMessageManagementViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadNetData {
    [[TCBuluoApi api] fetchMessageManagementList:^(NSArray *messageManagementList, NSError *error) {
        if (messageManagementList) {
            weakSelf.messageManagementList = messageManagementList;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageManagementList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMessageManagementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMessageManagementViewCell" forIndexPath:indexPath];
    cell.messageManagement = self.messageManagementList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TCMessageManagementViewCellDelegate

- (void)messageManagementViewCell:(TCMessageManagementViewCell *)cell didClickSwitchButtonWithType:(NSString *)messageType open:(BOOL)open {
    [MBProgressHUD showHUD:YES];
    cell.messageManagement.isOpen = open;
    
    [[TCBuluoApi api] modifyMessageState:open messageType:messageType reuslt:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
        } else {
            cell.messageManagement.isOpen = !open;
            [weakSelf.tableView reloadData];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"修改失败，%@", reason]];
        }
    }];
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
