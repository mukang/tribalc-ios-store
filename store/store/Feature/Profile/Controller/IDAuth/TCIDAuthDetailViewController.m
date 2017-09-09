//
//  TCIDAuthDetailViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCIDAuthDetailViewController.h"
#import "TCIDAuthViewController.h"
#import "TCAppSettingViewController.h"

#import <TCCommonLibs/TCCommonButton.h>
#import "TCIDAuthDetailViewCell.h"

#import "TCBuluoApi.h"

@interface TCIDAuthDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCStoreInfo *storeInfo;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCIDAuthDetailViewController {
    __weak TCIDAuthDetailViewController *weakSelf;
}

- (instancetype)initWithIDAuthStatus:(TCIDAuthStatus)authStatus {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _authStatus = authStatus;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
    
    [self setupNavBar];
    if (self.authStatus == TCIDAuthStatusProcessing) {
        [self setupSubviewsWithProcessing];
    } else {
        [self setupSubviewsWithFinished];
    }
    
}

- (void)setupNavBar {
    self.navigationItem.title = @"身份认证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviewsWithProcessing {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_process_icon"]];
    [self.view addSubview:imageView];
    
    TCCommonButton *backButton = [TCCommonButton buttonWithTitle:@"返回上一页" target:self action:@selector(handleClickBackButton:)];
    [self.view addSubview:backButton];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"身份验证中";
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = TCBlackColor;
    titleLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleLable];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(111, 108));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TCRealValue(106));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(weakSelf.view.mas_top).with.offset(TCRealValue(321));
    }];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(backButton.mas_top).with.offset(-18);
    }];
}

- (void)setupSubviewsWithFinished {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCIDAuthDetailViewCell class] forCellReuseIdentifier:@"TCIDAuthDetailViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
    
    if ([self.storeInfo.authenticationStatus isEqualToString:@"SUCCESS"]) {
        [self setupSuccessStatus];
    }
    if ([self.storeInfo.authenticationStatus isEqualToString:@"FAILURE"]) {
        [self setupFailuerStatus];
    }
}

- (void)setupSuccessStatus {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_success_icon"]];
    [self.tableView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(116, 95));
        make.top.equalTo(weakSelf.tableView.mas_top).with.offset(150);
        make.left.equalTo(weakSelf.tableView.mas_left).with.offset(TCScreenWidth - 116);
    }];
}

- (void)setupFailuerStatus {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auth_failure_icon"]];
    [self.tableView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135, 65));
        make.top.equalTo(weakSelf.tableView.mas_top).with.offset(170);
        make.left.equalTo(weakSelf.tableView.mas_left).with.offset(TCScreenWidth - 145);
    }];
    
    TCCommonButton *recommitButton = [TCCommonButton buttonWithTitle:@"重新提交认证" target:self action:@selector(handleClickRecommitButton:)];
    [self.view addSubview:recommitButton];
    [recommitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(TCRealValue(-70));
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCIDAuthDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCIDAuthDetailViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"真实姓名";
            cell.subtitleLabel.text = self.storeInfo.legalPersonName;
            break;
        case 1:
            cell.titleLabel.text = @"出生日期";
//            if (self.userInfo.birthday) {
//                NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.storeInfo.birthday / 1000];
//                cell.subtitleLabel.text = [self.dateFormatter stringFromDate:date];
//            } else {
//                cell.subtitleLabel.text = @"";
//            }
            break;
        case 2:
//            cell.titleLabel.text = @"性别";
//            if ([self.userInfo.sex isEqualToString:@"MALE"]) {
//                cell.subtitleLabel.text = @"男";
//            } else if ([self.userInfo.sex isEqualToString:@"FEMALE"]) {
//                cell.subtitleLabel.text = @"女";
//            } else {
//                cell.subtitleLabel.text = @"";
//            }
            break;
        case 3:
            cell.titleLabel.text = @"身份证号";
            cell.subtitleLabel.text = self.storeInfo.legalPersonIdNo;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - Actions

- (void)handleClickBackButton:(id)sender {
    TCAppSettingViewController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)handleClickRecommitButton:(UIButton *)sender {
    TCIDAuthViewController *vc = [[TCIDAuthViewController alloc] initWithNibName:@"TCIDAuthViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormatter;
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
