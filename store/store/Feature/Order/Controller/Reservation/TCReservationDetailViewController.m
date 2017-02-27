//
//  TCReservationDetailViewController.m
//  store
//
//  Created by 穆康 on 2017/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReservationDetailViewController.h"

#import "TCCommonButton.h"
#import "TCReservationStoreViewCell.h"
#import "TCReservationInfoViewCell.h"
#import "TCReservationAddressViewCell.h"
#import "TCReservationStatusView.h"

#import "TCBuluoApi.h"

@interface TCReservationDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TCReservation *reservation;

@property (weak, nonatomic) TCCommonButton *rejectButton;
@property (weak, nonatomic) TCCommonButton *passButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCReservationDetailViewController {
    __weak TCReservationDetailViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"预定详情";
    
    [self setupSubviews];
    [self loadNetData];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCReservationStoreViewCell class] forCellReuseIdentifier:@"TCReservationStoreViewCell"];
    [tableView registerClass:[TCReservationInfoViewCell class] forCellReuseIdentifier:@"TCReservationInfoViewCell"];
    [tableView registerClass:[TCReservationAddressViewCell class] forCellReuseIdentifier:@"TCReservationAddressViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (void)showBottomButton {
    if ([self.reservation.status isEqualToString:@"PROCESSING"]) {
        TCCommonButton *rejectButton = [TCCommonButton bottomButtonWithTitle:@"取消预定"
                                                                       color:TCCommonButtonColorBlue
                                                                      target:self
                                                                      action:@selector(handleClickRejectButton:)];
        [self.view addSubview:rejectButton];
        self.rejectButton = rejectButton;
        
        TCCommonButton *passButton = [TCCommonButton bottomButtonWithTitle:@"确认通过"
                                                                     color:TCCommonButtonColorOrange
                                                                    target:self
                                                                    action:@selector(handleClickPassButton:)];
        [self.view addSubview:passButton];
        self.passButton = passButton;
        
        [rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
            make.left.bottom.equalTo(weakSelf.view);
            make.right.equalTo(passButton.mas_left);
        }];
        [passButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
            make.width.equalTo(rejectButton.mas_width);
            make.right.bottom.equalTo(weakSelf.view);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-49);
        }];
    }
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchDetailReservation:self.reservationID result:^(TCReservation *reservation, NSError *error) {
        if (reservation) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.reservation = reservation;
            [weakSelf showBottomButton];
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出后重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.reservation) {
        return 3;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
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
    if (indexPath.section == 0) {
        TCReservationStoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCReservationStoreViewCell" forIndexPath:indexPath];
        cell.reservation = self.reservation;
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            TCReservationAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCReservationAddressViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"地点";
            cell.addressLabel.text = self.reservation.address;
            return cell;
        } else {
            TCReservationInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCReservationInfoViewCell" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"时间";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.reservation.appointTime / 1000]]];
            } else if (indexPath.row == 1) {
                cell.titleLabel.text = @"人数";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"%zd", self.reservation.personNum];
            } else {
                cell.titleLabel.text = @"餐厅";
                cell.subtitleLabel.text = self.reservation.storeName;
            }
            return cell;
        }
    } else {
        TCReservationInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCReservationInfoViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"联系人";
            cell.subtitleLabel.text = self.reservation.linkman;
        } else {
            cell.titleLabel.text = @"联系电话";
            cell.subtitleLabel.text = self.reservation.phone;
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 131;
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.reservation.status isEqualToString:@"CANNEL"]) {
            return 45;
        } else {
            return 71;
        }
    } else {
        return 9;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGRect frame;
        if ([self.reservation.status isEqualToString:@"CANNEL"]) {
            frame = CGRectMake(0, 0, TCScreenWidth, 45);
        } else {
            frame = CGRectMake(0, 0, TCScreenWidth, 71);
        }
        TCReservationStatusView *view = [[TCReservationStatusView alloc] initWithFrame:frame];
        view.status = self.reservation.status;
        return view;
    } else {
        return nil;
    }
}

#pragma mark - Actions

- (void)handleClickRejectButton:(UIButton *)sender {
    [self handleChangeReservationStatus:@"FAILURE"];
}

- (void)handleClickPassButton:(UIButton *)sender {
    [self handleChangeReservationStatus:@"SUCCEED"];
}

- (void)handleChangeReservationStatus:(NSString *)status {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeReservationStatus:status reservationID:self.reservation.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.reservation.status = status;
            [weakSelf handleRefreshTableView];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"修改预定状态失败，%@", reason]];
        }
    }];
}

- (void)handleRefreshTableView {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    self.rejectButton.hidden = YES;
    self.passButton.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
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
