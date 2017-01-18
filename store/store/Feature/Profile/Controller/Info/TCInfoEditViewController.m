//
//  TCInfoEditViewController.m
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCInfoEditViewController.h"

#import "TCInfoEditViewCell.h"

#import "TCBuluoApi.h"
#import <Masonry.h>

@interface TCInfoEditViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UITextField *textField;

@end

@implementation TCInfoEditViewController {
    __weak TCInfoEditViewController *weakSelf;
}

- (instancetype)initWithEditType:(TCInfoEditType)editType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _editType = editType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.textField isFirstResponder]) {
        [self.textField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    if (self.editType == TCInfoEditTypeName) {
        self.navigationItem.title = @"店铺名称";
    } else {
        self.navigationItem.title = @"联系人姓名";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickSaveItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.rowHeight = 53;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCInfoEditViewCell class] forCellReuseIdentifier:@"TCInfoEditViewCell"];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCInfoEditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCInfoEditViewCell" forIndexPath:indexPath];
    if (self.editType == TCInfoEditTypeName) {
        cell.titleLabel.text = @"店铺名称";
        cell.textField.text = self.name;
        cell.placeholder = @"请输入店铺名称";
    } else {
        cell.titleLabel.text = @"联系人姓名";
        cell.textField.text = self.linkman;
        cell.placeholder = @"请输入联系人姓名";
    }
    cell.textField.delegate = self;
    self.textField = cell.textField;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[textField textInputMode] primaryLanguage] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - Actions

- (void)handleClickSaveItem:(UIBarButtonItem *)sender {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    
    if (self.editType == TCInfoEditTypeName) {
        [self handleChangeName];
    } else {
        [self handleChangeLinkman];
    }
}

- (void)handleChangeName {
    NSString *name = self.textField.text;
    if (name.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入店铺名称"];
        return;
    }
    if ([name hasPrefix:@" "]) {
        [MBProgressHUD showHUDWithMessage:@"店铺名称不能以空格开头"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeStoreName:name result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.editBlock) {
                weakSelf.editBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"店铺名称修改失败，%@", reason]];
        }
    }];
}

- (void)handleChangeLinkman {
    NSString *linkman = self.textField.text;
    if (linkman.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入联系人姓名"];
        return;
    }
    if ([linkman hasPrefix:@" "]) {
        [MBProgressHUD showHUDWithMessage:@"联系人姓名不能以空格开头"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeStoreLinkman:linkman result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.editBlock) {
                weakSelf.editBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"联系人姓名修改失败，%@", reason]];
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
