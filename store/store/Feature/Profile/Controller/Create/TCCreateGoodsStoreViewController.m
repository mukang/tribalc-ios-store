//
//  TCCreateGoodsStoreViewController.m
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsStoreViewController.h"

#import "TCCommonButton.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCGoodsStoreRecommendViewCell.h"

@interface TCCreateGoodsStoreViewController () <UITableViewDataSource, UITableViewDelegate, TCCommonInputViewCellDelegate>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCCreateGoodsStoreViewController {
    __weak TCCreateGoodsStoreViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.weakSelf = self;
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
    self.navigationItem.title = @"创建商铺";
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
    [tableView registerClass:[TCGoodsStoreRecommendViewCell class] forCellReuseIdentifier:@"TCGoodsStoreRecommendViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *nextButton = [TCCommonButton bottomButtonWithTitle:@"提  交"
                                                                 color:TCCommonButtonColorOrange
                                                                target:self
                                                                action:@selector(handleClickCommitButton:)];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"商家名称";
                cell.placeholder = @"请输入商家名称";
                cell.delegate = self;
                return cell;
            } else {
                TCCommonSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonSubtitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"经营品类";
                cell.subtitleLabel.text = @"商品";
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"主要电话";
                return cell;
            } else if (indexPath.row == 1) {
                TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"其他电话";
                cell.placeholder = @"请输入其他电话";
                cell.delegate = self;
                return cell;
            } else {
                TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"发货地址";
                cell.subtitleLabel.text = @"请选择发货地址";
                return cell;
            }
        }
            break;
        case 2:
        {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"店铺LOGO";
            } else {
                cell.titleLabel.text = @"店铺环境图";
            }
            return cell;
        }
            break;
        case 3:
        {
            TCGoodsStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStoreRecommendViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"推荐理由";
            cell.subtitleLabel.text = @"请输入商铺推荐理由：";
            return cell;
        }
            break;
            
        default:
            return 0;
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 206;
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

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickCommitButton:(UIButton *)sender {
    
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
