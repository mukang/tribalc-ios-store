//
//  TCCityPickerView.m
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCityPickerView.h"

static CGFloat const duration = 0.25;

NSString *const TCCityPickierViewProvinceKey = @"TCCityPickierViewProvinceKey";
NSString *const TCCityPickierViewCityKey = @"TCCityPickierViewCityKey";
NSString *const TCCityPickierViewCountryKey = @"TCCityPickierViewCountryKey";

@interface TCCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIPickerView *pickerView;

@property (copy, nonatomic) NSArray *provinceArray;
@property (copy, nonatomic) NSArray *cityArray;
@property (copy, nonatomic) NSArray *countryArray;

@end

@implementation TCCityPickerView {
    __weak TCCityPickerView *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithController:(UIViewController *)controller {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        weakSelf = self;
        sourceController = controller;
        [self initPrivate];
    }
    return self;
}

- (void)show {
    if (!sourceController) return;
    
    UIView *superView;
    if (sourceController.navigationController) {
        superView = sourceController.navigationController.view;
    } else {
        superView = sourceController.view;
    }
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.containerView.y = TCScreenHeight - weakSelf.containerView.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.containerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Private Methods

- (void)initPrivate {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [self addSubview:backgroundView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBgView:)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    CGFloat containerViewH = 256;
    CGFloat buttonW = 60;
    CGFloat buttonH = 40;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"取消"
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                                                }];
    [cancelButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    attTitle = [[NSAttributedString alloc] initWithString:@"取消"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(10, 164, 177)
                                                            }];
    [cancelButton setAttributedTitle:attTitle forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(handleClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(20, 0, buttonW, buttonH);
    [containerView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    attTitle = [[NSAttributedString alloc] initWithString:@"确定"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                            }];
    [confirmButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    attTitle = [[NSAttributedString alloc] initWithString:@"确定"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(10, 164, 177)
                                                            }];
    [confirmButton setAttributedTitle:attTitle forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(handleClickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = CGRectMake(containerView.width - 20 - buttonW, 0, buttonW, buttonH);
    [containerView addSubview:confirmButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = TCRGBColor(242, 242, 242);
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.frame = CGRectMake(0, 40, containerView.width, containerView.height - 40);
    [containerView addSubview:pickerView];
    self.pickerView = pickerView;
    
    [self loadData];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.countryArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (component == 0) {
        NSDictionary *provinceDict = [self.provinceArray objectAtIndex:row];
        title = [provinceDict objectForKey:@"n"];
    } else if (component == 1) {
        NSDictionary *cityDict = [self.cityArray objectAtIndex:row];
        title = [cityDict objectForKey:@"n"];
    } else {
        NSDictionary *countryDict = [self.countryArray objectAtIndex:row];
        title = [countryDict objectForKey:@"n"];
    }
    
    return [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                         NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                         }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDict = [self.provinceArray objectAtIndex:row];
        self.cityArray = [provinceDict objectForKey:@"l"];
        [pickerView reloadComponent:1];
        
        NSDictionary *cityDict = [self.cityArray firstObject];
        self.countryArray = [cityDict objectForKey:@"l"];
        [pickerView reloadComponent:2];
    } else if (component == 1) {
        [pickerView selectedRowInComponent:1];
        
        NSDictionary *cityDict = [self.cityArray objectAtIndex:row];
        self.countryArray = [cityDict objectForKey:@"l"];
        [pickerView reloadComponent:2];
    } else {
        [pickerView selectedRowInComponent:2];
    }
}

#pragma mark - Actions

- (void)handleClickCancelButton:(UIButton *)sender {
    [self dismiss];
}

- (void)handleClickConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cityPickerView:didClickConfirmButtonWithCityInfo:)]) {
        NSDictionary *cityInfo = [self getCurrentSelectedInfo];
        [self.delegate cityPickerView:self didClickConfirmButtonWithCityInfo:cityInfo];
    }
    [self dismiss];
}

- (void)handleTapBgView:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

#pragma mark - Get Current Info

- (NSDictionary *)getCurrentSelectedInfo {
    NSInteger provinceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger countryIndex = [self.pickerView selectedRowInComponent:2];
    
    NSString *province = self.provinceArray[provinceIndex][@"n"];
    NSString *city = self.cityArray.count != 0 ? self.cityArray[cityIndex][@"n"] : @"";
    NSString *country = self.countryArray.count != 0 ? self.countryArray[countryIndex][@"n"] : @"";
    
    return @{
             TCCityPickierViewProvinceKey : province,
             TCCityPickierViewCityKey     : city,
             TCCityPickierViewCountryKey  : country
             };
}


#pragma mark - Load Data

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *dictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.provinceArray = dictArray;
    NSDictionary *provinceDict = [self.provinceArray firstObject];
    self.cityArray = provinceDict[@"l"];
    NSDictionary *cityDict = [self.cityArray firstObject];
    self.countryArray = cityDict[@"l"];
    
    [self.pickerView reloadAllComponents];
}

@end
