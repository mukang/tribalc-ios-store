//
//  TCBussinessAuthSuccessController.m
//  store
//
//  Created by 王帅锋 on 17/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBussinessAuthSuccessController.h"
#import "TCBuluoApi.h"
#import "TCStoreAuthSuccessCell.h"
#import <Masonry.h>

@interface TCBussinessAuthSuccessController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TCBussinessAuthSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"审核成功";
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = TCRealValue(242);
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.sectionHeaderHeight = TCRealValue(55);
        _tableView.sectionFooterHeight = 0.01;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MIN)];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreAuthSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreAuthSuccessCell"];
    
    if (cell == nil) {
        cell = [[TCStoreAuthSuccessCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCStoreAuthSuccessCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.imageStr = self.authenticationInfo.businessLicense;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.authenticationInfo.idCardPicture) {
                if (self.authenticationInfo.idCardPicture.count) {
                    NSString *str = self.authenticationInfo.idCardPicture[0];
                    if ([str isKindOfClass:[NSString class]]) {
                        cell.imageStr = str;
                    }
                }
            }
        }else {
            if (self.authenticationInfo.idCardPicture) {
                if (self.authenticationInfo.idCardPicture.count == 2) {
                    NSString *str = self.authenticationInfo.idCardPicture[1];
                    if ([str isKindOfClass:[NSString class]]) {
                        cell.imageStr = str;
                    }
                }
            }
        }
    }else {
        cell.imageStr = self.authenticationInfo.tradeLicense;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(55);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(55))];
    view.backgroundColor = TCRGBColor(230, 230, 230);
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, TCRealValue(10), TCScreenWidth, TCRealValue(45))];
    l.font = [UIFont systemFontOfSize:16];
    l.textColor = TCBlackColor;
    l.backgroundColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentLeft;
    [view addSubview:l];
    if (section == 0) {
        l.text = @"    营业执照";
    }else if (section == 1) {
        l.text = @"    身份证";
    }else {
        l.text = @"    行业许可证";
    }
    
    return view;
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
