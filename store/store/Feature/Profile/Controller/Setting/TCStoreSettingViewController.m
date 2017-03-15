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
#import "TCNavigationController.h"
#import "TCStoreAddressViewController.h"
#import "TCBusinessHoursViewController.h"

#import "TCCommonButton.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonSwitchViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreRecommendViewCell.h"
#import "TCCookingStyleViewCell.h"
#import "TCStoreFacilitiesViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreFeature.h"
#import "TCStoreCategoryInfo.h"
#import "NSObject+TCModel.h"
#import "TCBusinessLicenceViewController.h"

@interface TCStoreSettingViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCCommonInputViewCellDelegate,
TCCommonSwitchViewCellDelegate,
TCStoreRecommendViewCellDelegate,
TCCookingStyleViewCellDelegate,
TCStoreFacilitiesViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;
@property (strong, nonatomic) TCStoreSetMealMeta *storeSetMealMeta;
@property (strong, nonatomic) TCStoreCategoryInfo *categoryInfo;
@property (copy, nonatomic) NSArray *serviceCategoryInfoArray;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (copy, nonatomic) NSArray *facilities;
@property (copy, nonatomic) NSArray *cookingStyles;
@property (nonatomic) NSInteger currentCookingStylesIndex;

@property (nonatomic, getter=isEditEnabled) BOOL editEnabled;
@property (nonatomic) BOOL originInteractivePopGestureEnabled;

@property (weak, nonatomic) TCNavigationController *nav;

@end

@implementation TCStoreSettingViewController {
    __weak TCStoreSettingViewController *weakSelf;
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
    [tableView registerClass:[TCCommonSwitchViewCell class] forCellReuseIdentifier:@"TCCommonSwitchViewCell"];
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCStoreRecommendViewCell class] forCellReuseIdentifier:@"TCStoreRecommendViewCell"];
    [tableView registerClass:[TCCookingStyleViewCell class] forCellReuseIdentifier:@"TCCookingStyleViewCell"];
    [tableView registerClass:[TCStoreFacilitiesViewCell class] forCellReuseIdentifier:@"TCStoreFacilitiesViewCell"];
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
    [self loadStoreDetailInfo];
}

- (void)loadStoreDetailInfo {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreDetailInfo:^(TCStoreDetailInfo *storeDetailInfo, NSError *error) {
        if (storeDetailInfo) {
            weakSelf.storeDetailInfo = storeDetailInfo;
            for (TCStoreCategoryInfo *categoryInfo in self.serviceCategoryInfoArray) {
                if ([categoryInfo.category isEqualToString:storeDetailInfo.category]) {
                    self.categoryInfo = categoryInfo;
                    break;
                }
            }
            [weakSelf loadStoreSetMealMeta];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出后重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取店铺信息失败，%@", reason]];
        }
    }];
}

- (void)loadStoreSetMealMeta {
    [[TCBuluoApi api] fetchStoreSetMeals:^(NSArray *storeSetMeals, NSError *error) {
        if (storeSetMeals) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.storeSetMealMeta = storeSetMeals[0];
            [weakSelf setupSubviews];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出后重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取店铺信息失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.storeDetailInfo.category isEqualToString:@"REPAST"]) {
        return 5;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
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
                    cell.textField.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
                case 1:
                {
                    TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"分店名称";
                    cell.placeholder = @"请填写分店名称";
                    cell.textField.text = self.storeDetailInfo.subbranchName;
                    cell.textField.keyboardType = UIKeyboardTypeDefault;
                    cell.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                    cell.delegate = self;
                    cell.textField.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
                case 2:
                {
                    TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"经营品类";
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"服务>%@", self.categoryInfo.name];
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                    cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                    currentCell = cell;
                }
                    break;
                case 3:
                {
                    TCCommonSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSwitchViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"座位预定";
                    cell.switchControl.on = self.storeSetMealMeta.reservable;
                    cell.delegate = self;
                    cell.switchControl.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
                case 4:
                {
                    TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"人均消费";
                    cell.placeholder = @"请填写人均消费";
                    cell.textField.text = self.storeSetMealMeta.personExpense ? [NSString stringWithFormat:@"%zd", self.storeSetMealMeta.personExpense] : nil;
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                    cell.delegate = self;
                    cell.textField.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"主要电话";
                    cell.subtitleLabel.text = self.storeDetailInfo.phone;
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                    cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                    currentCell = cell;
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
                    cell.textField.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
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
                    cell.textField.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
                case 3:
                {
                    TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"门店地址";
                    if (self.storeDetailInfo.address) {
                        cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.storeDetailInfo.province, self.storeDetailInfo.city, self.storeDetailInfo.district, self.storeDetailInfo.address];
                        cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                    } else {
                        cell.subtitleLabel.text = @"请设置门店地址";
                        cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                    }
                    currentCell = cell;
                }
                    break;
                case 4:
                {
                    TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = @"营业时间";
                    cell.subtitleLabel.textAlignment = NSTextAlignmentLeft;
                    if (self.storeDetailInfo.businessHours) {
                        cell.subtitleLabel.text = self.storeDetailInfo.businessHours;
                        cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                    } else {
                        cell.subtitleLabel.text = @"请设置营业时间";
                        cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                    }
                    currentCell = cell;
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                    cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                    cell.titleLabel.text = @"LOGO";
                    cell.subtitleLabel.text = self.storeDetailInfo.logo ? @"1张" : nil;
                    currentCell = cell;
                }
                    break;
                case 1:
                {
                    TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                    cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                    cell.titleLabel.text = @"环境图";
                    if (self.storeDetailInfo.pictures.count) {
                        cell.subtitleLabel.text = [NSString stringWithFormat:@"%zd张", self.storeDetailInfo.pictures.count];
                    } else {
                        cell.subtitleLabel.text = nil;
                    }
                    currentCell = cell;
                }
                    break;
                    
                default:
                {
                    TCStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreRecommendViewCell" forIndexPath:indexPath];
                    cell.delegate = self;
                    if (indexPath.row == 2) {
                        cell.titleLabel.text = @"店铺介绍";
                        cell.subtitleLabel.text = @"请输入店铺介绍：";
                        cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
                        cell.textView.text = self.storeDetailInfo.desc;
                    } else if (indexPath.row == 3) {
                        cell.titleLabel.text = @"推荐理由";
                        cell.subtitleLabel.text = @"请输入店铺推荐理由：";
                        cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
                        cell.textView.text = self.storeSetMealMeta.recommendedReason;
                    } else {
                        cell.titleLabel.text = @"推荐话题";
                        cell.subtitleLabel.text = @"请输入店铺推荐话题：";
                        cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
                        cell.textView.text = self.storeSetMealMeta.topics;
                    }
                    cell.textView.userInteractionEnabled = self.isEditEnabled;
                    currentCell = cell;
                }
                    break;
            }
            break;
        case 3:
        {
            TCStoreFacilitiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreFacilitiesViewCell" forIndexPath:indexPath];
            cell.hidePrompt = YES;
            cell.features = self.facilities;
            cell.delegate = self;
            cell.contentView.userInteractionEnabled = self.isEditEnabled;
            currentCell = cell;
        }
            break;
        case 4:
        {
            TCCookingStyleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCookingStyleViewCell" forIndexPath:indexPath];
            cell.features = self.cookingStyles;
            cell.delegate = self;
            cell.contentView.userInteractionEnabled = self.isEditEnabled;
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
    switch (indexPath.section) {
        case 0:
            return 45;
            break;
        case 1:
            return 45;
            break;
        case 2:
            if (indexPath.row <= 1) {
                return 45;
            } else {
                return 162;
            }
            break;
        case 3:
            return TCRealValue(242) + 0.5;
            break;
        case 4:
            return TCRealValue(218);
            break;
            
        default:
            return 0;
            break;
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
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            [self handleSelectStoreAddressCell];
        } else if (indexPath.row == 4) {
            [self handleSelectBusinessHoursCell];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self handleSelectStoreLogoCell];
        } else if (indexPath.row == 1) {
            [self handleSelectStoreSurroundingCell];
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.storeDetailInfo.name = textField.text;
        } else if (indexPath.row == 1) {
            self.storeDetailInfo.subbranchName = textField.text;
        } else if (indexPath.row == 4) {
            self.storeSetMealMeta.personExpense = [textField.text integerValue];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            self.storeDetailInfo.otherPhone = textField.text;
        } else if (indexPath.row == 2) {
            self.storeDetailInfo.markPlace = textField.text;
        }
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCCommonSwitchViewCellDelegate

- (void)commonSwitchViewCell:(TCCommonSwitchViewCell *)cell didChangeSwitchControlWithOn:(BOOL)isOn {
    self.storeSetMealMeta.reservable = isOn;
}

#pragma mark - TCStoreRecommendViewCellDelegate

- (BOOL)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textViewShouldBeginEditing:(YYTextView *)textView {
    self.currentIndexPath = [self.tableView indexPathForCell:cell];
    return YES;
}

- (void)storeRecommendViewCell:(TCStoreRecommendViewCell *)cell textViewDidEndEditing:(YYTextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 2) {
        self.storeDetailInfo.desc = textView.text;
    } else if (indexPath.row == 3) {
        self.storeSetMealMeta.recommendedReason = textView.text;
    } else if (indexPath.row == 4) {
        self.storeSetMealMeta.topics = textView.text;
    }
}

#pragma mark - TCStoreFacilitiesViewCellDelegate

- (void)storeFacilitiesViewCell:(TCStoreFacilitiesViewCell *)cell didSelectItemAtIndex:(NSInteger)index {
    TCStoreFeature *storeFeature = self.facilities[index];
    storeFeature.selected = !storeFeature.isSelected;
    
    cell.features = self.facilities;
}

#pragma mark - TCCookingStyleViewCellDelegate

- (void)cookingStyleViewCell:(TCCookingStyleViewCell *)cell didSelectItemAtIndex:(NSInteger)index {
    TCStoreFeature *preStoreFeature = self.cookingStyles[self.currentCookingStylesIndex];
    if (index == self.currentCookingStylesIndex) {
        preStoreFeature.selected = !preStoreFeature.isSelected;
    } else {
        preStoreFeature.selected = NO;
        self.currentCookingStylesIndex = index;
        TCStoreFeature *storeFeature = self.cookingStyles[self.currentCookingStylesIndex];
        storeFeature.selected = YES;
    }
    
    cell.features = self.cookingStyles;
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
    if (!self.storeSetMealMeta.personExpense) {
        [MBProgressHUD showHUDWithMessage:@"请填写人均消费"];
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
    if (self.storeDetailInfo.logo.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请上传店铺LOGO"];
        return;
    }
    if (self.storeDetailInfo.pictures.count == 0) {
        [MBProgressHUD showHUDWithMessage:@"请上传店铺环境图"];
        return;
    }
    if (self.storeDetailInfo.desc.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写店铺介绍"];
        return;
    }
    if (self.storeSetMealMeta.recommendedReason.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写推荐理由"];
        return;
    }
    if (self.storeSetMealMeta.topics.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写推荐话题"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (TCStoreFeature *feature in self.facilities) {
        if (feature.isSelected) {
            [tempArray addObject:feature.name];
        }
    }
    if (tempArray.count > 0) {
        self.storeDetailInfo.facilities = [tempArray copy];
    }
    if ([self.storeDetailInfo.category isEqualToString:@"REPAST"]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TCStoreFeature *feature in self.cookingStyles) {
            if (feature.isSelected) {
                [temp addObject:feature.name];
                break;
            }
        }
        if (temp.count == 0) {
            [MBProgressHUD showHUDWithMessage:@"请选择菜系类型"];
            return;
        }
        self.storeDetailInfo.cookingStyle = [temp copy];
    }
    
    [self handleChangeStoreDetailInfo];
}

- (void)handleChangeStoreDetailInfo {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeStoreDetailInfo:self.storeDetailInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf handleChangeStoreSetMeal];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"修改店铺信息失败，%@", reason]];
        }
    }];
}

- (void)handleChangeStoreSetMeal {
    [[TCBuluoApi api] changeStoreSetMeal:self.storeSetMealMeta result:^(BOOL success, NSError *error) {
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
    TCBusinessLicenceViewController *bussVc = [[TCBusinessLicenceViewController alloc] init];
    [self.navigationController pushViewController:bussVc animated:YES];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 1 && self.currentIndexPath.section != 2) return;
    
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)handleSelectStoreSurroundingCell {
    TCStoreSurroundingViewController *vc = [[TCStoreSurroundingViewController alloc] init];
    vc.storeDetailInfo = self.storeDetailInfo;
    vc.editSurroundingCompletion = ^() {
        weakSelf.storeSetMealMeta.pictures = weakSelf.storeDetailInfo.pictures;
        if (weakSelf.storeDetailInfo.pictures.count) {
            weakSelf.storeSetMealMeta.mainPicture = weakSelf.storeDetailInfo.pictures[0];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Override Methods

- (NSArray *)serviceCategoryInfoArray {
    if (_serviceCategoryInfoArray == nil) {
        NSArray *array = @[
                           @{@"name": @"餐饮", @"icon": @"category_repast", @"category": @"REPAST"},
                           @{@"name": @"美容", @"icon": @"category_hairdressing", @"category": @"HAIRDRESSING"},
                           @{@"name": @"健身", @"icon": @"category_fitness", @"category": @"FITNESS"},
                           @{@"name": @"休闲娱乐", @"icon": @"category_entertainment", @"category": @"ENTERTAINMENT"},
                           @{@"name": @"养生", @"icon": @"category_keephealthy", @"category": @"KEEPHEALTHY"}
                           ];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreCategoryInfo *categoryInfo = [[TCStoreCategoryInfo alloc] initWithObjectDictionary:dic];
            [temp addObject:categoryInfo];
        }
        _serviceCategoryInfoArray = [NSArray arrayWithArray:temp];
    }
    return _serviceCategoryInfoArray;
}

- (NSArray *)facilities {
    if (_facilities == nil) {
        NSArray *array = @[
                           @{@"name": @"Wi-Fi"},
                           @{@"name": @"停车位"},
                           @{@"name": @"地铁"},
                           @{@"name": @"近商圈"},
                           @{@"name": @"宝宝椅"},
                           @{@"name": @"有包间"},
                           @{@"name": @"商务宴请"},
                           @{@"name": @"适合小聚"},
                           @{@"name": @"残疾人设施"},
                           @{@"name": @"有酒吧区域"},
                           @{@"name": @"周末早午餐"},
                           @{@"name": @"酒店内餐厅"},
                           @{@"name": @"会员权益"},
                           @{@"name": @"代客泊车"},
                           @{@"name": @"有观景位"},
                           @{@"name": @"有机食物"},
                           @{@"name": @"可带宠物"}
                           ];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreFeature *feature = [[TCStoreFeature alloc] initWithObjectDictionary:dic];
            for (NSString *name in self.storeDetailInfo.facilities) {
                if ([feature.name isEqualToString:name]) {
                    feature.selected = YES;
                }
            }
            [tempArray addObject:feature];
        }
        _facilities = [NSArray arrayWithArray:tempArray];
    }
    return _facilities;
}

- (NSArray *)cookingStyles {
    if (_cookingStyles == nil) {
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
        NSString *name;
        if (self.storeDetailInfo.cookingStyle.count) {
            name = self.storeDetailInfo.cookingStyle[0];
        }
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = array[i];
            TCStoreFeature *feature = [[TCStoreFeature alloc] initWithObjectDictionary:dic];
            if ([feature.name isEqualToString:name]) {
                feature.selected = YES;
                self.currentCookingStylesIndex = i;
            }
            [tempArray addObject:feature];
        }
        _cookingStyles = [NSArray arrayWithArray:tempArray];
    }
    return _cookingStyles;
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
