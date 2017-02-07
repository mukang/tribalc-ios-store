//
//  TCCreateGoodsStoreViewController.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsStoreViewController.h"
#import "TCStoreAddressViewController.h"
#import "TCStoreLogoUploadViewController.h"
#import "TCStoreSurroundingViewController.h"

#import "TCCommonButton.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreRecommendViewCell.h"
#import "TCGoodsStoreRecommendViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreCategoryInfo.h"

@interface TCCreateGoodsStoreViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TCCommonInputViewCellDelegate,
TCStoreRecommendViewCellDelegate,
YYTextViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation TCCreateGoodsStoreViewController {
    __weak TCCreateGoodsStoreViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.weakSelf = self;
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.title = @"创建商铺";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开店手册"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickManualItem:)];
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
    [tableView registerClass:[TCGoodsStoreRecommendViewCell class] forCellReuseIdentifier:@"TCGoodsStoreRecommendViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *nextButton = [TCCommonButton bottomButtonWithTitle:@"提  交"
                                                                 color:TCCommonButtonColorOrange
                                                                target:self
                                                                action:@selector(handleClickCommitButton:)];
    [self.view addSubview:nextButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(nextButton.mas_top);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.bottom.right.equalTo(weakSelf.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"商家名称";
                cell.placeholder = @"请填写商家名称";
                cell.textField.text = self.storeDetailInfo.name;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                cell.delegate = self;
                return cell;
            } else {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"经营品类";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"商品>%@", self.categoryInfo.name];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"主要电话";
                cell.subtitleLabel.text = self.storeDetailInfo.phone;
                return cell;
            } else if (indexPath.row == 1) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"其他电话";
                cell.placeholder = @"请填写其他电话";
                cell.textField.text = self.storeDetailInfo.otherPhone;
                cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.delegate = self;
                return cell;
            } else {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"发货地址";
                cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                if (self.storeDetailInfo.address) {
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.storeDetailInfo.province, self.storeDetailInfo.city, self.storeDetailInfo.district, self.storeDetailInfo.address];
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                } else {
                    cell.subtitleLabel.text = @"请设置发货地址";
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                }
                return cell;
            }
        }
            break;
        case 2:
        {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
            cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"LOGO";
                cell.subtitleLabel.text = self.storeDetailInfo.logo ? @"1张" : nil;
            } else {
                cell.titleLabel.text = @"环境图";
                if (self.storeDetailInfo.pictures.count) {
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"%zd张", self.storeDetailInfo.pictures.count];
                } else {
                    cell.subtitleLabel.text = nil;
                }
            }
            return cell;
        }
            break;
        case 3:
        {
            TCGoodsStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStoreRecommendViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"店铺介绍";
            cell.subtitleLabel.text = @"请输入店铺介绍：";
            cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
            cell.textView.text = self.storeDetailInfo.desc;
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
            return 0;
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        return 206;
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
    if (indexPath.section == 1 && indexPath.row == 2) {
        [self handleSelectStoreAddressCell];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self handleSelectStoreLogoCell];
        } else {
            [self handleSelectStoreSurroundingCell];
        }
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
        self.storeDetailInfo.otherPhone = textField.text;
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

- (BOOL)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (void)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textViewDidEndEditing:(YYTextView *)textView {
    self.currentIndexPath = nil;
    self.storeDetailInfo.desc = textView.text;
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

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickCommitButton:(UIButton *)sender {
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
    [[TCBuluoApi api] createStore:self.storeDetailInfo result:^(TCStoreInfo *storeInfo, NSError *error) {
        if (storeInfo) {
            [MBProgressHUD hideHUD:YES];
            TCLog(@"创建成功");
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"创建商铺失败，%@", reason]];
        }
    }];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 3) return;
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height - 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height - 49, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.tableView scrollToRowAtIndexPath:weakSelf.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)handleSelectStoreAddressCell {
    TCStoreAddressViewController *vc = [[TCStoreAddressViewController alloc] init];
    TCStoreAddress *storeAddress = [[TCStoreAddress alloc] init];
    storeAddress.province = self.storeDetailInfo.province;
    storeAddress.city = self.storeDetailInfo.city;
    storeAddress.district = self.storeDetailInfo.district;
    storeAddress.address = self.storeDetailInfo.address;
    vc.storeAddress = storeAddress;
    vc.editAddressCompletion = ^(TCStoreAddress *storeAddress) {
        weakSelf.storeDetailInfo.province = storeAddress.province;
        weakSelf.storeDetailInfo.city = storeAddress.city;
        weakSelf.storeDetailInfo.district = storeAddress.district;
        weakSelf.storeDetailInfo.address = storeAddress.address;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSelectStoreLogoCell {
    TCStoreLogoUploadViewController *vc = [[TCStoreLogoUploadViewController alloc] init];
    vc.logo = self.storeDetailInfo.logo;
    vc.uploadLogoCompletion = ^(NSString *logo) {
        weakSelf.storeDetailInfo.logo = logo;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleSelectStoreSurroundingCell {
    TCStoreSurroundingViewController *vc = [[TCStoreSurroundingViewController alloc] init];
    vc.storeDetailInfo = self.storeDetailInfo;
    vc.editSurroundingCompletion = ^() {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (TCStoreDetailInfo *)storeDetailInfo {
    if (_storeDetailInfo == nil) {
        _storeDetailInfo = [[TCStoreDetailInfo alloc] init];
        TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
        _storeDetailInfo.ID = storeInfo.ID;
        _storeDetailInfo.logo = storeInfo.logo;
        _storeDetailInfo.name = storeInfo.name;
        _storeDetailInfo.phone = storeInfo.phone;
        _storeDetailInfo.storeType = @"GOODS";
    }
    return _storeDetailInfo;
}

- (void)setCategoryInfo:(TCStoreCategoryInfo *)categoryInfo {
    _categoryInfo = categoryInfo;
    
    self.storeDetailInfo.category = categoryInfo.category;
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
