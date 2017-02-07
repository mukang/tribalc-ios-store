//
//  TCStoreSettingViewController.m
//  store
//
//  Created by 穆康 on 2017/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreSettingViewController.h"
#import "TCProfileViewController.h"
#import "TCStoreLogoUploadViewController.h"
#import "TCStoreSurroundingViewController.h"

#import "TCCommonButton.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreRecommendViewCell.h"
#import "TCStoreFacilitiesViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreFeature.h"
#import "NSObject+TCModel.h"

@interface TCStoreSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCStoreSettingViewController {
    __weak TCStoreSettingViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickEditItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCStoreRecommendViewCell class] forCellReuseIdentifier:@"TCStoreRecommendViewCell"];
    [tableView registerClass:[TCStoreFacilitiesViewCell class] forCellReuseIdentifier:@"TCStoreFacilitiesViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if ([[TCBuluoApi api].currentUserSession.storeInfo.storeAuthenticationStatus isEqualToString:@"SUCCEED"]) {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(weakSelf.view);
        }];
    } else {
        TCCommonButton *commitButton = [TCCommonButton bottomButtonWithTitle:@"店铺认证"
                                                                       color:TCCommonButtonColorOrange
                                                                      target:self
                                                                      action:@selector(handleClickAuthenticationButton:)];
        [self.view addSubview:commitButton];
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(commitButton.mas_top);
        }];
        [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
            make.left.bottom.right.equalTo(weakSelf.view);
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    TCProfileViewController *vc = self.navigationController.childViewControllers[0];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)handleClickEditItem:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickSaveItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)handleClickSaveItem:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickEditItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)handleClickAuthenticationButton:(UIButton *)sender {
    
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
