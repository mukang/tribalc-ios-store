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
@property (strong, nonatomic) UIView *headerView;
@property (weak, nonatomic) UILabel *headerTitleLabel;

@property (strong, nonatomic) TCMessageManagementWrapper *messageManagementWrapper;

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
    [[TCBuluoApi api] fetchMessageManagementWrapper:^(TCMessageManagementWrapper *messageManagementWrapper, NSError *error) {
        if (messageManagementWrapper) {
            weakSelf.messageManagementWrapper = messageManagementWrapper;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.messageManagementWrapper.additional.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.messageManagementWrapper.primary.count;
    } else {
        return self.messageManagementWrapper.additional.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMessageManagementViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMessageManagementViewCell" forIndexPath:indexPath];
    TCMessageManagement *messageManagement = nil;
    if (indexPath.section == 0) {
        messageManagement = self.messageManagementWrapper.primary[indexPath.row];
    } else {
        messageManagement = self.messageManagementWrapper.additional[indexPath.row];
    }
    cell.messageManagement = messageManagement;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.messageManagementWrapper.additional.count == 0) {
        return CGFLOAT_MIN;
    }
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.messageManagementWrapper.additional.count == 0) {
        return nil;
    }
    
    UIView *containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, 0, TCScreenWidth, 30);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(20);
        make.centerY.equalTo(containerView);
    }];
    
    if (section == 0) {
        titleLabel.text = @"个人";
    } else {
        titleLabel.text = @"企业";
    }
    
    return containerView;
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

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        UILabel *headerTitleLabel = [[UILabel alloc] init];
        headerTitleLabel.textColor = TCBlackColor;
        headerTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_headerView addSubview:headerTitleLabel];
        self.headerTitleLabel = headerTitleLabel;
        [headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(20);
            make.centerY.equalTo(_headerView);
        }];
    }
    return _headerView;
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
