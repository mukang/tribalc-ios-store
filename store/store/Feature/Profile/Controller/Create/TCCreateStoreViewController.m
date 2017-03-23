//
//  TCCreateStoreViewController.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateStoreViewController.h"
#import "TCStoreAddressViewController.h"
#import "TCBusinessHoursViewController.h"
#import "TCCreateStoreNextViewController.h"

#import "TCCommonButton.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCCookingStyleViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreCategoryInfo.h"
#import "TCStoreFeature.h"

#import "NSObject+TCModel.h"

@interface TCCreateStoreViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TCCommonInputViewCellDelegate,
TCCookingStyleViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;

@property (copy, nonatomic) NSArray *features;
@property (nonatomic) NSInteger currentFeatureIndex;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation TCCreateStoreViewController {
    __weak TCCreateStoreViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.currentFeatureIndex = 0;
    
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
    self.navigationItem.title = @"创建店铺";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开店手册"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickManualItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCCommonInputViewCell class] forCellReuseIdentifier:@"TCCommonInputViewCell"];
    [tableView registerClass:[TCCommonSubtitleViewCell class] forCellReuseIdentifier:@"TCCommonSubtitleViewCell"];
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCCookingStyleViewCell class] forCellReuseIdentifier:@"TCCookingStyleViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *nextButton = [TCCommonButton bottomButtonWithTitle:@"下一步"
                                                                 color:TCCommonButtonColorOrange
                                                                target:self
                                                                action:@selector(handleClickNextButton:)];
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
    if ([self.storeDetailInfo.category isEqualToString:@"REPAST"]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"商家名称";
                cell.placeholder = @"请填写商家名称";
                cell.textField.text = self.storeDetailInfo.name;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                cell.delegate = self;
                return cell;
            }
                break;
            case 1:
            {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"分店名称";
                cell.placeholder = @"请填写分店名称";
                cell.textField.text = self.storeDetailInfo.name;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                cell.delegate = self;
                return cell;
            }
                break;
            case 2:
            {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"经营品类";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"服务>%@", self.categoryInfo.name];
                return cell;
            }
                break;
                
            default:
                return nil;
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"主要电话";
                cell.subtitleLabel.text = self.storeDetailInfo.phone;
                return cell;
            }
                break;
            case 1:
            {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"其他电话";
                cell.placeholder = @"请填写其他电话";
                cell.textField.text = self.storeDetailInfo.otherPhone;
                cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                cell.delegate = self;
                return cell;
            }
                break;
            case 2:
            {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"所在区域";
                cell.placeholder = @"请填写店铺所在区域，如：三里屯";
                cell.textField.text = self.storeDetailInfo.markPlace;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                cell.delegate = self;
                return cell;
            }
                break;
            case 3:
            {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"门店地址";
                if (self.storeDetailInfo.address) {
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.storeDetailInfo.province, self.storeDetailInfo.city, self.storeDetailInfo.district, self.storeDetailInfo.address];
                    cell.subtitleLabel.textColor = TCBlackColor;
                } else {
                    cell.subtitleLabel.text = @"请设置门店地址";
                    cell.subtitleLabel.textColor = TCGrayColor;
                }
                return cell;
            }
                break;
            case 4:
            {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"营业时间";
                if (self.storeDetailInfo.businessHours) {
                    cell.subtitleLabel.text = self.storeDetailInfo.businessHours;
                    cell.subtitleLabel.textColor = TCBlackColor;
                } else {
                    cell.subtitleLabel.text = @"请设置营业时间";
                    cell.subtitleLabel.textColor = TCGrayColor;
                }
                return cell;
            }
                break;
                
            default:
                return nil;
                break;
        }
    } else {
        TCCookingStyleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCookingStyleViewCell" forIndexPath:indexPath];
        cell.features = self.features;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return TCRealValue(218);
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
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            [self handleSelectStoreAddressCell];
        } else if (indexPath.row == 4) {
            [self handleSelectBusinessHoursCell];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentIndexPath = [self.tableView indexPathForCell:cell];
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.storeDetailInfo.name = textField.text;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        self.storeDetailInfo.subbranchName = textField.text;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        self.storeDetailInfo.otherPhone = textField.text;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        self.storeDetailInfo.markPlace = textField.text;
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCCookingStyleViewCellDelegate

- (void)cookingStyleViewCell:(TCCookingStyleViewCell *)cell didSelectItemAtIndex:(NSInteger)index {
    TCStoreFeature *preStoreFeature = self.features[self.currentFeatureIndex];
    if (index == self.currentFeatureIndex) {
        preStoreFeature.selected = !preStoreFeature.isSelected;
    } else {
        preStoreFeature.selected = NO;
        self.currentFeatureIndex = index;
        TCStoreFeature *storeFeature = self.features[self.currentFeatureIndex];
        storeFeature.selected = YES;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)handleClickNextButton:(UIButton *)sender {
    if (self.storeDetailInfo.name.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写商家名称"];
        return;
    }
    if (self.storeDetailInfo.markPlace.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写所在区域"];
        return;
    }
    if (self.storeDetailInfo.address.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请设置门店地址"];
        return;
    }
    if (self.storeDetailInfo.businessHours.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请设置营业时间"];
        return;
    }
    if ([self.storeDetailInfo.category isEqualToString:@"REPAST"]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (TCStoreFeature *feature in self.features) {
            if (feature.isSelected) {
                [tempArray addObject:feature.name];
                break;
            }
        }
        if (tempArray.count == 0) {
            [MBProgressHUD showHUDWithMessage:@"请选择菜系类型"];
            return;
        }
        self.storeDetailInfo.cookingStyle = [tempArray copy];
    }
    
    TCCreateStoreNextViewController *vc = [[TCCreateStoreNextViewController alloc] init];
    vc.storeDetailInfo = self.storeDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)handleSelectBusinessHoursCell {
    TCBusinessHoursViewController *vc = [[TCBusinessHoursViewController alloc] init];
    if (self.storeDetailInfo.businessHours) {
        NSArray *parts = [self.storeDetailInfo.businessHours componentsSeparatedByString:@"-"];
        if (parts.count == 2) {
            vc.openTime = [parts firstObject];
            vc.closeTime = [parts lastObject];
        }
    }
    vc.businessHoursBlock = ^(NSString *openTime, NSString *closeTime) {
        self.storeDetailInfo.businessHours = [NSString stringWithFormat:@"%@-%@", openTime, closeTime];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 1 || self.currentIndexPath.row != 2) return;
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height - 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height - 49, 0);
    
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

- (TCStoreDetailInfo *)storeDetailInfo {
    if (_storeDetailInfo == nil) {
        _storeDetailInfo = [[TCStoreDetailInfo alloc] init];
        TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
        _storeDetailInfo.ID = storeInfo.ID;
        _storeDetailInfo.logo = storeInfo.logo;
        _storeDetailInfo.name = storeInfo.name;
        _storeDetailInfo.phone = storeInfo.phone;
        _storeDetailInfo.storeType = @"SET_MEAL";
    }
    return _storeDetailInfo;
}

- (void)setCategoryInfo:(TCStoreCategoryInfo *)categoryInfo {
    _categoryInfo = categoryInfo;
    
    self.storeDetailInfo.category = categoryInfo.category;
}

- (NSArray *)features {
    if (_features == nil) {
        NSArray *array = @[
                           @{@"name": @"西餐"},
                           @{@"name": @"咖啡厅"},
                           @{@"name": @"日料"},
                           @{@"name": @"自助餐"},
                           @{@"name": @"粤菜"},
                           @{@"name": @"意大利菜"},
                           @{@"name": @"火锅"},
                           @{@"name": @"融合菜"},
                           @{@"name": @"韩国料理"},
                           @{@"name": @"东南亚菜"},
                           @{@"name": @"西班牙菜"},
                           @{@"name": @"法国菜"},
                           @{@"name": @"云南菜"},
                           @{@"name": @"台湾菜"},
                           @{@"name": @"德国菜"},
                           @{@"name": @"其他"}
                           ];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreFeature *feature = [[TCStoreFeature alloc] initWithObjectDictionary:dic];
            [tempArray addObject:feature];
        }
        _features = [NSArray arrayWithArray:tempArray];
    }
    return _features;
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
