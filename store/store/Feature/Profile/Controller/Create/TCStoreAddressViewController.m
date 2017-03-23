//
//  TCStoreAddressViewController.m
//  store
//
//  Created by 穆康 on 2017/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreAddressViewController.h"

#import "TCCommonButton.h"
#import "TCCityPickerView.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreSearchAddressViewCell.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TCStoreAddressViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
TCStoreSearchAddressViewCellDelegate,
MAMapViewDelegate,
AMapSearchDelegate,
TCCityPickerViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCommonButton *saveButton;

@property (weak, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapSearchAPI *searchAPI;
@property (strong, nonatomic) MAPointAnnotation *annotation;

@property (weak, nonatomic) UIView *promptView;
@property (weak, nonatomic) UILabel *addressLabel;

@end

@implementation TCStoreAddressViewController {
    __weak TCStoreAddressViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.title = @"门店地址";
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
    tableView.rowHeight = 44;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [tableView registerClass:[TCStoreSearchAddressViewCell class] forCellReuseIdentifier:@"TCStoreSearchAddressViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *saveButton = [TCCommonButton bottomButtonWithTitle:@"保  存"
                                                                 color:TCCommonButtonColorOrange
                                                                target:self
                                                                action:@selector(handleClickSaveButton:)];
    [self.view addSubview:saveButton];
    self.saveButton = saveButton;
    
    CGFloat mapY = 97;
    CGFloat mapH = TCScreenHeight - mapY - 49 - TCRealValue(60);
    CGRect mapFrame = CGRectMake(0, mapY, TCScreenWidth, mapH);
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:mapFrame];
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    UIView *promptView = [[UIView alloc] init];
    promptView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    promptView.size = CGSizeMake(TCRealValue(263), 24);
    promptView.centerX = mapView.width * 0.5;
    promptView.y = mapView.y + 7;
    promptView.layer.cornerRadius = 12;
    promptView.layer.masksToBounds = YES;
    promptView.hidden = YES;
    [self.view addSubview:promptView];
    self.promptView = promptView;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"请先进行手动搜索，如位置不准确，再手动调整";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.font = [UIFont systemFontOfSize:10];
    promptLabel.frame = promptView.bounds;
    [promptView addSubview:promptLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = TCRGBColor(252, 108, 38);
    addressLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    AMapSearchAPI *searchAPI = [[AMapSearchAPI alloc] init];
    searchAPI.delegate = self;
    self.searchAPI = searchAPI;
    if (self.storeAddress.address.length) {
        NSString *searchAddress = [NSString stringWithFormat:@"%@%@%@%@", self.storeAddress.province, self.storeAddress.city, self.storeAddress.district, self.storeAddress.address];
        [self geocodeSearchWithAddress:searchAddress];
    }
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(97);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(49);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.saveButton.mas_top).with.offset(TCRealValue(-48));
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
    }];
}

// 发起地理编码查询
- (void)geocodeSearchWithAddress:(NSString *)address {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [self.searchAPI AMapGeocodeSearch:geo];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"所在地区";
        if (self.storeAddress.province) {
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%@%@%@", self.storeAddress.province, self.storeAddress.city, self.storeAddress.district];
            cell.subtitleLabel.textColor = TCBlackColor;
        } else {
            cell.subtitleLabel.text = @"请选择所在地区";
            cell.subtitleLabel.textColor = TCGrayColor;
        }
        return cell;
    } else {
        TCStoreSearchAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreSearchAddressViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.textField.delegate = self;
        cell.textField.text = self.storeAddress.address ?: nil;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
    if (indexPath.row == 0) {
        TCCityPickerView *pickerView = [[TCCityPickerView alloc] initWithController:self];
        pickerView.delegate = self;
        [pickerView show];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.storeAddress.address = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCStoreSearchAddressViewCellDelegate

- (void)storeSearchAddressViewCell:(TCStoreSearchAddressViewCell *)cell didClickSearchButtonWithAddress:(NSString *)address {
    if (self.storeAddress.province.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请选择所在地区"];
        return;
    }
    if (self.storeAddress.address.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写详细地址"];
        return;
    }
    
    NSString *searchAddress = [NSString stringWithFormat:@"%@%@%@%@", self.storeAddress.province, self.storeAddress.city, self.storeAddress.district, self.storeAddress.address];
    [self geocodeSearchWithAddress:searchAddress];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self.tableView endEditing:YES];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self.tableView endEditing:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.tableView endEditing:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:YES];
}

#pragma mark - AMapSearchDelegate

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        return;
    }
    AMapGeocode *geocode = response.geocodes[0];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geocode.location.latitude, geocode.location.longitude);
    [self.mapView setZoomLevel:17.5 animated:NO];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    self.promptView.hidden = NO;
    self.addressLabel.text = geocode.formattedAddress;
    
    if (self.annotation == nil) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.lockedScreenPoint = CGPointMake(self.mapView.width * 0.5, self.mapView.height * 0.5);
        annotation.lockedToScreen = YES;
        [self.mapView addAnnotation:annotation];
        self.annotation = annotation;
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    
}

#pragma mark - TCCityPickerViewDelegate

- (void)cityPickerView:(TCCityPickerView *)view didClickConfirmButtonWithCityInfo:(NSDictionary *)cityInfo {
    
    self.storeAddress.province = cityInfo[TCCityPickierViewProvinceKey];
    self.storeAddress.city = cityInfo[TCCityPickierViewCityKey];
    self.storeAddress.district = cityInfo[TCCityPickierViewCountryKey];
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickSaveButton:(UIButton *)sender {
    if (self.storeAddress.province.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请选择所在地区"];
        return;
    }
    if (self.storeAddress.address.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写详细地址"];
        return;
    }
    if (!self.annotation) {
        [MBProgressHUD showHUDWithMessage:@"请点击搜索按钮，在地图上进行搜索"];
        return;
    }
    self.storeAddress.coordinate = @[@(self.annotation.coordinate.longitude), @(self.annotation.coordinate.latitude)];
    
    if (self.editAddressCompletion) {
        self.editAddressCompletion(self.storeAddress);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
