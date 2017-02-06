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

@end

@implementation TCCreateStoreViewController {
    __weak TCCreateStoreViewController *weakSelf;
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
            return 4;
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
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"门店地址";
                if (self.storeDetailInfo.address) {
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.storeDetailInfo.province, self.storeDetailInfo.city, self.storeDetailInfo.district, self.storeDetailInfo.address];
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                } else {
                    cell.subtitleLabel.text = @"请设置门店地址";
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
                }
                return cell;
            }
                break;
            case 3:
            {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"营业时间";
                if (self.storeDetailInfo.businessHours) {
                    cell.subtitleLabel.text = self.storeDetailInfo.businessHours;
                    cell.subtitleLabel.textColor = TCRGBColor(42, 42, 42);
                } else {
                    cell.subtitleLabel.text = @"请设置营业时间";
                    cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
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
        if (indexPath.row == 2) {
            [self handleSelectStoreAddressCell];
        } else if (indexPath.row == 3) {
            [self handleSelectBusinessHoursCell];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - TCCommonInputViewCellDelegate

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCCookingStyleViewCellDelegate

- (void)cookingStyleViewCell:(TCCookingStyleViewCell *)cell didSelectItemAtIndex:(NSInteger)index {
    TCStoreFeature *storeFeature = self.features[index];
    storeFeature.selected = !storeFeature.isSelected;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickNextButton:(UIButton *)sender {
    if (self.storeDetailInfo.name.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写商家名称"];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
