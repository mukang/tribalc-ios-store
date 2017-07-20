//
//  TCPrivilegeViewController.m
//  store
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeViewController.h"
#import "TCPrivilegeCell.h"
#import "TCBuluoApi.h"

#define kBackGroundColor TCRGBColor(239, 245, 245)

@interface TCPrivilegeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *privileges;

@end

@implementation TCPrivilegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠策略";
    self.view.backgroundColor = kBackGroundColor;
    [self loadData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStorePrivilegeWithActive:@"false" result:^(NSArray *privilegeList, NSError *error) {
        @StrongObj(self)
        if ([privilegeList isKindOfClass:[NSArray class]]) {
            [MBProgressHUD hideHUD:YES];
            self.privileges = privilegeList;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.privileges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPrivilegeCell" forIndexPath:indexPath];
    cell.privilege = self.privileges[indexPath.row];
    return cell;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat scale = width > 375.0 ? 3 : 2;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = TCRealValue(72);
        [_tableView registerClass:[TCPrivilegeCell class] forCellReuseIdentifier:@"TCPrivilegeCell"];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TCRealValue(47)+2/scale)];
        headerView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = headerView;
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 7, width, 1/scale)];
        lineView1.backgroundColor = TCSeparatorLineColor;
        [headerView addSubview:lineView1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), width, 40)];
        label.text = @"    买单优惠";
        label.textColor = TCGrayColor;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:label];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), width, 1/scale)];
        lineView2.backgroundColor = TCSeparatorLineColor;
        [headerView addSubview:lineView2];
    }
    return _tableView;
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
