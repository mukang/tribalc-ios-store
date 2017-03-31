//
//  TCBusinessHoursViewController.m
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBusinessHoursViewController.h"

#import "TCBusinessHoursViewCell.h"

#import <TCCommonLibs/TCDatePickerView.h>

typedef NS_ENUM(NSInteger, TCBusinessHours) {
    TCBusinessHoursOpenTime,
    TCBusinessHoursCloseTime
};

@interface TCBusinessHoursViewController () <UITableViewDataSource, UITableViewDelegate, TCBusinessHoursViewCellDelegate, TCDatePickerViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) TCBusinessHours businessHours;

@end

@implementation TCBusinessHoursViewController {
    __weak TCBusinessHoursViewController *weakSelf;
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
    self.navigationItem.title = @"营业时间";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickSaveItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 76;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCBusinessHoursViewCell class] forCellReuseIdentifier:@"TCBusinessHoursViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCBusinessHoursViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBusinessHoursViewCell" forIndexPath:indexPath];
    cell.openTimeLabel.text = self.openTime ?: nil;
    cell.closeTimeLabel.text = self.closeTime ?: nil;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - TCBusinessHoursViewCellDelegate

- (void)didTapOpenTimeLabelInBusinessHoursViewCell:(TCBusinessHoursViewCell *)cell {
    self.businessHours = TCBusinessHoursOpenTime;
    [self handleShowDatePickerViewWithTime:self.openTime];
}

- (void)didTapCloseTimeLabelInBusinessHoursViewCell:(TCBusinessHoursViewCell *)cell {
    self.businessHours = TCBusinessHoursCloseTime;
    [self handleShowDatePickerViewWithTime:self.closeTime];
}

#pragma mark - TCDatePickerViewDelegate

- (void)didClickConfirmButtonInDatePickerView:(TCDatePickerView *)view {
    if (self.businessHours == TCBusinessHoursOpenTime) {
        self.openTime = [self.dateFormatter stringFromDate:view.datePicker.date];
    } else {
        self.closeTime = [self.dateFormatter stringFromDate:view.datePicker.date];
    }
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)handleClickSaveItem:(UIBarButtonItem *)sender {
    if (!self.openTime) {
        [MBProgressHUD showHUDWithMessage:@"请设置开门时间"];
        return;
    }
    if (!self.closeTime) {
        [MBProgressHUD showHUDWithMessage:@"请设置关门时间"];
        return;
    }
    
    if (self.businessHoursBlock) {
        self.businessHoursBlock(self.openTime, self.closeTime);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleShowDatePickerViewWithTime:(NSString *)time {
    TCDatePickerView *datePickerView = [[TCDatePickerView alloc] initWithController:self];
    datePickerView.datePicker.datePickerMode = UIDatePickerModeTime;
    datePickerView.datePicker.date = time ? [self.dateFormatter dateFromString:time] : [NSDate date];
    datePickerView.delegate = self;
    [datePickerView show];
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return _dateFormatter;
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
