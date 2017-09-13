//
//  TCIDAuthViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCIDAuthViewController.h"
#import "TCIDAuthDetailViewController.h"
#import "TCAppSettingViewController.h"
#import "TCNavigationController.h"

#import "TCCommonInputViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/TCDatePickerView.h>
#import "TCGenderPickerView.h"

#import "TCBuluoApi.h"
#import "TCNotificationNames.h"

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypePhone = 0,
    TCInputCellTypeName,
    TCInputCellTypeIDNumber
};

@interface TCIDAuthViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TCCommonInputViewCellDelegate,
TCDatePickerViewDelegate,
TCGenderPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TCCommonButton *commitButton;
@property (assign, nonatomic) BOOL originalInteractivePopGestureEnabled;
@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) TCUserIDAuthInfo *authInfo;

@end

@implementation TCIDAuthViewController {
    __weak TCIDAuthViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    self.title = @"商户认证";
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
}

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    if (self.isFromEditPhone) {
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        UILabel *label = [[UILabel alloc] init];
        label.text = @"手机号修改成功，请进行实名认证";
        label.textColor = TCLightGrayColor;
        label.font = [UIFont systemFontOfSize:14];
        [self.tableView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tableView).offset(20);
            make.right.equalTo(self.tableView).offset(-20);
            make.top.equalTo(self.tableView).offset(-20);
            make.height.equalTo(@20);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    TCCommonButton *commitButton = [TCCommonButton buttonWithTitle:@"认证" target:self action:@selector(handleClickCommitButton:)];
    commitButton.centerX = TCScreenWidth * 0.5;
    commitButton.y = TCScreenHeight - commitButton.height - TCRealValue(70) - 64;
    [self.tableView addSubview:commitButton];
    self.commitButton = commitButton;
    
    UINib *nib = [UINib nibWithNibName:@"TCCommonInputViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommonInputViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.placeholder = self.placeholderArray[indexPath.row];
    cell.delegate = self;
    switch (indexPath.row) {
        case TCInputCellTypeName:
            cell.content = self.authInfo.name;
            cell.keyboardType = UIKeyboardTypeDefault;
            cell.inputEnabled = YES;
            cell.autocorrectionType = UITextAutocorrectionTypeDefault;
            break;
        case TCInputCellTypePhone:
            cell.inputEnabled = NO;
            cell.content = [TCBuluoApi api].currentUserSession.storeInfo.phone;
            break;
        case TCInputCellTypeIDNumber:
            cell.content = self.authInfo.idNo;
            cell.keyboardType = UIKeyboardTypeASCIICapable;
            cell.inputEnabled = YES;
            cell.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TCInputCellTypePhone) {
        return 50;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case TCInputCellTypeName:
            self.authInfo.name = textField.text;
            break;
        case TCInputCellTypeIDNumber:
            self.authInfo.idNo = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
    TCAppSettingViewController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)handleClickCommitButton:(TCCommonButton *)sender {
    if (!self.authInfo.name.length) {
        [MBProgressHUD showHUDWithMessage:@"请您输入真实姓名"];
        return;
    }

    if (!self.authInfo.idNo.length) {
        [MBProgressHUD showHUDWithMessage:@"请您输入身份证号"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] authorizeUserIdentity:self.authInfo result:^(TCStoreInfo *storeInfo, NSError *error) {
        if (storeInfo) {
            [MBProgressHUD hideHUD:YES];
        // 认证成功 跳到认证详情页
            TCIDAuthDetailViewController *detailVc = [[TCIDAuthDetailViewController alloc] initWithIDAuthStatus:TCIDAuthStatusFinished];
            [weakSelf.navigationController pushViewController:detailVc animated:YES];
            
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"认证失败，%@", reason]];
        }
    }];
}

#pragma mark - Override Methods

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"手机号:", @"输入姓名:", @"输入身份证号:"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray {
    if (_placeholderArray == nil) {
        _placeholderArray = @[@"请输入手机号", @"请输入姓名", @"请输入身份证号码"];
    }
    return _placeholderArray;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormatter;
}

- (TCUserIDAuthInfo *)authInfo {
    if (_authInfo == nil) {
        _authInfo = [[TCUserIDAuthInfo alloc] init];
        _authInfo.name = nil;
        _authInfo.birthday = 0;
        _authInfo.personSex = nil;
        _authInfo.idNo = nil;
    }
    return _authInfo;
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
