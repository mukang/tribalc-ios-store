//
//  TCGoodsStoreSettingViewController.m
//  store
//
//  Created by 穆康 on 2017/2/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStoreSettingViewController.h"
#import "TCProfileViewController.h"
#import "TCStoreLogoUploadViewController.h"
#import "TCStoreAddressViewController.h"
#import "TCNavigationController.h"

#import "TCCommonButton.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreRecommendViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreCategoryInfo.h"
#import "NSObject+TCModel.h"
#import "TCBusinessLicenceViewController.h"

@interface TCGoodsStoreSettingViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCCommonInputViewCellDelegate,
TCStoreRecommendViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;
@property (strong, nonatomic) TCStoreCategoryInfo *categoryInfo;
@property (copy, nonatomic) NSArray *goodsCategoryInfoArray;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (nonatomic, getter=isEditEnabled) BOOL editEnabled;

@property (nonatomic) BOOL originInteractivePopGestureEnabled;

@property (weak, nonatomic) TCNavigationController *nav;

@end

@implementation TCGoodsStoreSettingViewController {
    __weak TCGoodsStoreSettingViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.editEnabled = NO;
    
    [self setupNavBar];
    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = !self.isBackForbidden;
    self.nav = nav;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
    
    self.nav.enableInteractivePopGesture = self.originInteractivePopGestureEnabled;
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.title = @"店铺信息";
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
    [tableView registerClass:[TCCommonInputViewCell class] forCellReuseIdentifier:@"TCCommonInputViewCell"];
    [tableView registerClass:[TCCommonSubtitleViewCell class] forCellReuseIdentifier:@"TCCommonSubtitleViewCell"];
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCStoreRecommendViewCell class] forCellReuseIdentifier:@"TCStoreRecommendViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if ([[TCBuluoApi api].currentUserSession.storeInfo.authenticationStatus isEqualToString:@"SUCCESS"]) {
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

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreDetailInfo:^(TCStoreDetailInfo *storeDetailInfo, NSError *error) {
        if (storeDetailInfo) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.storeDetailInfo = storeDetailInfo;
            for (TCStoreCategoryInfo *categoryInfo in self.goodsCategoryInfoArray) {
                if ([categoryInfo.category isEqualToString:storeDetailInfo.category]) {
                    self.categoryInfo = categoryInfo;
                    break;
                }
            }
            [weakSelf setupSubviews];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出后重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取店铺信息失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"商家名称";
                cell.placeholder = @"请填写商家名称";
                cell.textField.text = self.storeDetailInfo.name;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                cell.delegate = self;
                cell.textField.userInteractionEnabled = self.isEditEnabled;
                currentCell = cell;
            } else {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"经营品类";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"服务>%@", self.categoryInfo.name];
                cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                currentCell = cell;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"主要电话";
                cell.subtitleLabel.text = self.storeDetailInfo.phone;
                cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                currentCell = cell;
            } else if (indexPath.row == 1) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"其他电话";
                cell.placeholder = @"请填写其他电话";
                cell.textField.text = self.storeDetailInfo.otherPhone;
                cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.delegate = self;
                cell.textField.userInteractionEnabled = self.isEditEnabled;
                currentCell = cell;
            } else {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"发货地址";
                if (self.storeDetailInfo.address) {
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.storeDetailInfo.province, self.storeDetailInfo.city, self.storeDetailInfo.district, self.storeDetailInfo.address];
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                } else {
                    cell.subtitleLabel.text = @"请设置发货地址";
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                }
                currentCell = cell;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
                cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                cell.titleLabel.text = @"LOGO";
                cell.subtitleLabel.text = self.storeDetailInfo.logo ? @"1张" : nil;
                currentCell = cell;
            } else {
                TCStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreRecommendViewCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.titleLabel.text = @"店铺介绍";
                cell.subtitleLabel.text = @"请输入店铺介绍：";
                cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
                cell.textView.text = self.storeDetailInfo.desc;
                cell.textView.userInteractionEnabled = self.isEditEnabled;
                currentCell = cell;
            }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 162;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
    if (!self.isEditEnabled) return;
    if (indexPath.section == 1 && indexPath.row == 2) {
        [self handleSelectStoreAddressCell];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self handleSelectStoreLogoCell];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - TCCommonInputViewCellDelegate

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.storeDetailInfo.name = textField.text;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        if (indexPath.row == 1) {
            self.storeDetailInfo.otherPhone = textField.text;
        }
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCStoreRecommendViewCellDelegate

- (BOOL)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textViewShouldBeginEditing:(YYTextView *)textView {
    self.currentIndexPath = [self.tableView indexPathForCell:cell];
    return YES;
}

- (void)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textViewDidEndEditing:(YYTextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 2 && indexPath.row == 1) {
        self.storeDetailInfo.desc = textView.text;
    }
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.editEnabled = YES;
    [self.tableView reloadData];
}

- (void)handleClickSaveItem:(UIBarButtonItem *)sender {
    [weakSelf.tableView endEditing:YES];
    
    if (self.storeDetailInfo.name.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写商家名称"];
        return;
    }
    if (!self.storeDetailInfo.address) {
        [MBProgressHUD showHUDWithMessage:@"请设置发货地址"];
        return;
    }
    if (!self.storeDetailInfo.logo) {
        [MBProgressHUD showHUDWithMessage:@"请上传logo"];
        return;
    }
    if (self.storeDetailInfo.desc.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写店铺介绍"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeStoreDetailInfo:self.storeDetailInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
            weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                                          style:UIBarButtonItemStylePlain
                                                                                         target:self
                                                                                         action:@selector(handleClickEditItem:)];
            [weakSelf.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                                      forState:UIControlStateNormal];
            
            weakSelf.editEnabled = NO;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"修改店铺信息失败，%@", reason]];
        }
    }];
}

- (void)handleClickAuthenticationButton:(UIButton *)sender {
    TCBusinessLicenceViewController *businessVC = [[TCBusinessLicenceViewController alloc] init];
    [self.navigationController pushViewController:businessVC animated:YES];
}

- (void)handleSelectStoreAddressCell {
    TCStoreAddressViewController *vc = [[TCStoreAddressViewController alloc] init];
    TCStoreAddress *storeAddress = [[TCStoreAddress alloc] init];
    storeAddress.province = self.storeDetailInfo.province;
    storeAddress.city = self.storeDetailInfo.city;
    storeAddress.district = self.storeDetailInfo.district;
    storeAddress.address = self.storeDetailInfo.address;
    storeAddress.coordinate = self.storeDetailInfo.coordinate;
    vc.storeAddress = storeAddress;
    vc.editAddressCompletion = ^(TCStoreAddress *storeAddress) {
        weakSelf.storeDetailInfo.province = storeAddress.province;
        weakSelf.storeDetailInfo.city = storeAddress.city;
        weakSelf.storeDetailInfo.district = storeAddress.district;
        weakSelf.storeDetailInfo.address = storeAddress.address;
        weakSelf.storeDetailInfo.coordinate = storeAddress.coordinate;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSelectStoreLogoCell {
    TCStoreLogoUploadViewController *vc = [[TCStoreLogoUploadViewController alloc] init];
    vc.logo = self.storeDetailInfo.logo;
    vc.uploadLogoCompletion = ^(NSString *logo) {
        weakSelf.storeDetailInfo.logo = logo;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 2 && self.currentIndexPath.row != 1) return;
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat bottomPadding;
    if ([self.storeDetailInfo.authenticationStatus isEqualToString:@"SUCCESS"]) {
        bottomPadding = height;
    } else {
        bottomPadding = height - 49;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomPadding, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, bottomPadding, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.tableView scrollToRowAtIndexPath:weakSelf.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {
        weakSelf.currentIndexPath = nil;
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
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
