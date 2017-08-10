//
//  TCStoreDetailViewController.m
//  store
//
//  Created by 王帅锋 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDetailViewController.h"
#import "TCBuluoApi.h"
#import "TCDetailStore.h"
#import "TCStoreDetailLogoCell.h"
#import "TCStoreDesCell.h"
#import "TCStoreDetailPicturesCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <TCCommonLibs/TCCommonButton.h>

@interface TCStoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCDetailStore *detailStore;

@end

@implementation TCStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCRGBColor(239, 245, 245);
    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreDetailInfo:^(TCDetailStore *detailStore, NSError *error) {
        @StrongObj(self)
        if (detailStore) {
            [MBProgressHUD hideHUD:YES];
            self.detailStore = detailStore;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取店铺信息失败，%@", reason]];
        }
    }];
}

- (void)bang {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 75;
    } else if (indexPath.row == 11) {
        return 160;
    } else if (indexPath.row == 10) {
        return [tableView fd_heightForCellWithIdentifier:@"TCStoreDesCell" configuration:^(TCStoreDesCell *cell) {
            cell.des = self.detailStore.desc;
        }];
    } else {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TCStoreDetailLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreDetailLogoCell" forIndexPath:indexPath];
        cell.detailStore = self.detailStore;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 10) {
        TCStoreDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreDesCell" forIndexPath:indexPath];
        cell.des = self.detailStore.desc;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 11) {
        TCStoreDetailPicturesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreDetailPicturesCell" forIndexPath:indexPath];
        cell.pictures = self.detailStore.pictures;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = TCBlackColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textColor = TCBlackColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSMutableString *tagStr = [[NSMutableString alloc] init];
        if ([self.detailStore.tags isKindOfClass:[NSArray class]]) {
            for (NSString *str in self.detailStore.tags) {
                [tagStr appendString:str];
            }
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"名        称:";
                cell.detailTextLabel.text = self.detailStore.name;
                break;
                case 2:
                cell.detailTextLabel.text = self.detailStore.category;
                break;
                case 3:
                cell.textLabel.text = @"所  在  地:";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",self.detailStore.province, self.detailStore.city, self.detailStore.district];
                break;
                case 4:
                cell.textLabel.text = @"地        址:";
                cell.detailTextLabel.text = self.detailStore.address;
                break;
                case 5:
                cell.textLabel.text = @"电        话:";
                cell.detailTextLabel.text = self.detailStore.serviceLine;
                break;
                case 6:
                cell.textLabel.text = @"邮        箱";
                cell.detailTextLabel.text = self.detailStore.email;
                break;
            case 7:
                cell.textLabel.text = @"营业时间:";
                cell.detailTextLabel.text = self.detailStore.businessHours;
                break;
            case 8:
                cell.textLabel.text = @"人        均:";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",self.detailStore.avgprice];
                break;
            case 9:
                cell.textLabel.text = @"标        签:";
                cell.detailTextLabel.text = tagStr;
                break;
            default:
                break;
        }
        return cell;
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerClass:[TCStoreDesCell class] forCellReuseIdentifier:@"TCStoreDesCell"];
        [_tableView registerClass:[TCStoreDetailLogoCell class] forCellReuseIdentifier:@"TCStoreDetailLogoCell"];
        [_tableView registerClass:[TCStoreDetailPicturesCell class] forCellReuseIdentifier:@"TCStoreDetailPicturesCell"];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
        _tableView.tableFooterView = footerView;
        
        TCCommonButton *btn = [TCCommonButton buttonWithTitle:@"确认绑定" color:TCCommonButtonColorBlue target:self action:@selector(bang)];
        btn.frame = CGRectMake(30, 63, self.view.bounds.size.width-60, 40);
        btn.hidden = YES;
        [footerView addSubview:btn];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(8);
        }];
    }
    return _tableView;
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
