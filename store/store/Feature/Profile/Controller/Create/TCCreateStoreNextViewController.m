//
//  TCCreateStoreNextViewController.m
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateStoreNextViewController.h"
#import "TCStoreLogoUploadViewController.h"
#import "TCStoreSurroundingViewController.h"
#import "TCStoreSettingViewController.h"

#import "TCCommonButton.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCCommonSwitchViewCell.h"
#import "TCCommonInputViewCell.h"
#import "TCStoreRecommendViewCell.h"
#import "TCStoreFacilitiesViewCell.h"

#import "TCBuluoApi.h"
#import "TCStoreFeature.h"
#import "NSObject+TCModel.h"

@interface TCCreateStoreNextViewController () <UITableViewDataSource, UITableViewDelegate, TCCommonSwitchViewCellDelegate, TCCommonInputViewCellDelegate, TCStoreRecommendViewCellDelegate, TCStoreFacilitiesViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *features;
@property (strong, nonatomic) TCStoreSetMealMeta *storeSetMealMeta;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation TCCreateStoreNextViewController {
    __weak TCCreateStoreNextViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCCommonSwitchViewCell class] forCellReuseIdentifier:@"TCCommonSwitchViewCell"];
    [tableView registerClass:[TCCommonInputViewCell class] forCellReuseIdentifier:@"TCCommonInputViewCell"];
    [tableView registerClass:[TCStoreRecommendViewCell class] forCellReuseIdentifier:@"TCStoreRecommendViewCell"];
    [tableView registerClass:[TCStoreFacilitiesViewCell class] forCellReuseIdentifier:@"TCStoreFacilitiesViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *commitButton = [TCCommonButton bottomButtonWithTitle:@"提  交"
                                                                 color:TCCommonButtonColorOrange
                                                                target:self
                                                                action:@selector(handleClickCommitButton:)];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
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
        if (indexPath.row == 0) {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
            cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
            cell.titleLabel.text = @"LOGO";
            cell.subtitleLabel.text = self.storeDetailInfo.logo ? @"1张" : nil;
            return cell;
        } else if (indexPath.row == 1) {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
            cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
            cell.titleLabel.text = @"环境图";
            if (self.storeDetailInfo.pictures.count) {
                cell.subtitleLabel.text = [NSString stringWithFormat:@"%zd张", self.storeDetailInfo.pictures.count];
            } else {
                cell.subtitleLabel.text = nil;
            }
            return cell;
        } else if (indexPath.row == 2) {
            TCCommonSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSwitchViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"座位预定";
            cell.switchControl.on = self.storeSetMealMeta.reservable;
            cell.delegate = self;
            return cell;
        } else {
            TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"人均消费";
            cell.placeholder = @"请填写人均消费";
            cell.textField.text = self.storeSetMealMeta.personExpense ? [NSString stringWithFormat:@"%zd", self.storeSetMealMeta.personExpense] : nil;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.delegate = self;
            return cell;
        }
    } else if (indexPath.section == 1) {
        TCStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreRecommendViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"店铺介绍";
            cell.subtitleLabel.text = @"请输入店铺介绍：";
            cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
            cell.textView.text = self.storeDetailInfo.desc;
        } else if (indexPath.row == 1) {
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
        return cell;
    } else {
        TCStoreFacilitiesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreFacilitiesViewCell" forIndexPath:indexPath];
        cell.features = self.features;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    } else if (indexPath.section == 1) {
        return 162;
    } else {
        return TCRealValue(232) + 40.5;
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
    
    if (indexPath.section == 0) {
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

#pragma mark - TCCommonSwitchViewCellDelegate

- (void)commonSwitchViewCell:(TCCommonSwitchViewCell *)cell didChangeSwitchControlWithOn:(BOOL)isOn {
    self.storeSetMealMeta.reservable = isOn;
}

#pragma mark - TCCommonInputViewCellDelegate

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    self.storeSetMealMeta.personExpense = [textField.text integerValue];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        self.storeDetailInfo.desc = textView.text;
    } else if (indexPath.row == 1) {
        self.storeSetMealMeta.recommendedReason = textView.text;
    } else {
        self.storeSetMealMeta.topics = textView.text;
    }
}

#pragma mark - TCStoreFacilitiesViewCellDelegate

- (void)storeFacilitiesViewCell:(TCStoreFacilitiesViewCell *)cell didSelectItemAtIndex:(NSInteger)index {
    TCStoreFeature *storeFeature = self.features[index];
    storeFeature.selected = !storeFeature.isSelected;
    
    cell.features = self.features;
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
    if (self.storeDetailInfo.logo.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请上传店铺LOGO"];
        return;
    }
    if (self.storeDetailInfo.pictures.count == 0) {
        [MBProgressHUD showHUDWithMessage:@"请上传店铺环境图"];
        return;
    }
    if (!self.storeSetMealMeta.personExpense) {
        [MBProgressHUD showHUDWithMessage:@"请填写人均消费"];
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
    for (TCStoreFeature *feature in self.features) {
        if (feature.isSelected) {
            [tempArray addObject:feature.name];
        }
    }
    if (tempArray.count > 0) {
        self.storeDetailInfo.facilities = [tempArray copy];
    }
    
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] createStore:self.storeDetailInfo result:^(TCStoreInfo *storeInfo, NSError *error) {
        if (storeInfo) {
            [weakSelf handleCreateStoreSetMeal];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"创建店铺失败，%@", reason]];
        }
    }];
}

- (void)handleCreateStoreSetMeal {
    [[TCBuluoApi api] createStoreSetMeal:self.storeSetMealMeta result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            TCStoreSettingViewController *vc = [[TCStoreSettingViewController alloc] init];
            vc.navigationItem.title = @"店铺信息";
            vc.backForbidden = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationStoreDidCreated object:nil];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"创建店铺失败，%@", reason]];
        }
    }];
}

- (void)handleSelectStoreLogoCell {
    TCStoreLogoUploadViewController *vc = [[TCStoreLogoUploadViewController alloc] init];
    vc.logo = self.storeDetailInfo.logo;
    vc.uploadLogoCompletion = ^(NSString *logo) {
        weakSelf.storeDetailInfo.logo = logo;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 1) return;
    
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

#pragma mark - Override Methods

- (TCStoreSetMealMeta *)storeSetMealMeta {
    if (_storeSetMealMeta == nil) {
        _storeSetMealMeta = [[TCStoreSetMealMeta alloc] init];
        _storeSetMealMeta.name = self.storeDetailInfo.name;
        _storeSetMealMeta.pictures = self.storeDetailInfo.pictures;
        _storeSetMealMeta.category = self.storeDetailInfo.category;
    }
    return _storeSetMealMeta;
}

- (NSArray *)features {
    if (_features == nil) {
        NSArray *array = @[
                           @{@"name": @"Wi-Fi"},
                           @{@"name": @"停车场"},
                           @{@"name": @"地铁"},
                           @{@"name": @"近商圈"},
                           @{@"name": @"宝宝椅"},
                           @{@"name": @"商务宴请"},
                           @{@"name": @"适合小聚"},
                           @{@"name": @"残疾人设施"},
                           @{@"name": @"有酒吧区域"},
                           @{@"name": @"周末早午餐"},
                           @{@"name": @"酒店内餐厅"},
                           @{@"name": @"会员权益"},
                           @{@"name": @"代客泊车"},
                           @{@"name": @"有景观位"},
                           @{@"name": @"有机食物"},
                           @{@"name": @"可带宠物"}
                           ];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TCStoreFeature *feature = [[TCStoreFeature alloc] initWithObjectDictionary:dic];
            [tempArray addObject:feature];
        }
        TCStoreFeature *wifiFeature = tempArray[0];
        wifiFeature.selected = YES;
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
