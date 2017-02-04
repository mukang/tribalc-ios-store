//
//  TCCreateStoreNextViewController.m
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateStoreNextViewController.h"

#import "TCCommonButton.h"
#import "TCCommonIndicatorViewCell.h"
#import "TCStoreRecommendViewCell.h"
#import "TCStoreFacilitiesViewCell.h"

#import "TCBuluoApi.h"

@interface TCCreateStoreNextViewController () <UITableViewDataSource, UITableViewDelegate, YYTextViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *features;
@property (strong, nonatomic) TCStoreSetMealCreation *storeSetMealCreation;

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
    [tableView registerClass:[TCStoreRecommendViewCell class] forCellReuseIdentifier:@"TCStoreRecommendViewCell"];
    [tableView registerClass:[TCStoreFacilitiesViewCell class] forCellReuseIdentifier:@"TCStoreFacilitiesViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *commitButton = [TCCommonButton bottomButtonWithTitle:@"提  价"
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
            return 2;
            break;
        case 1:
            return 2;
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
        TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
        cell.subtitleLabel.textAlignment = NSTextAlignmentRight;
        cell.subtitleLabel.textColor = TCRGBColor(154, 154, 154);
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"LOGO";
            cell.subtitleLabel.text = self.storeDetailInfo.logo ? @"1张" : nil;
        } else {
            cell.titleLabel.text = @"环境图";
            if (self.storeDetailInfo.pictures.count) {
                cell.subtitleLabel.text = [NSString stringWithFormat:@"%zd张", self.storeDetailInfo.pictures.count];
            } else {
                cell.subtitleLabel.text = nil;
            }
        }
        return cell;
    } else if (indexPath.section == 1) {
        TCStoreRecommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreRecommendViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"推荐理由";
            cell.subtitleLabel.text = @"请输入店铺推荐理由：";
            cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
            cell.textView.text = self.storeDetailInfo.recommendedReason;
        } else {
            cell.titleLabel.text = @"推荐话题";
            cell.subtitleLabel.text = @"请输入店铺推荐话题：";
            cell.textView.placeholderText = @"例如：门前大桥下，游过一群鸭~";
            cell.textView.text = self.storeSetMealCreation.topics;
        }
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickCommitButton:(UIButton *)sender {
    
}

#pragma mark - Override Methods

- (TCStoreSetMealCreation *)storeSetMealCreation {
    if (_storeSetMealCreation == nil) {
        _storeSetMealCreation = [[TCStoreSetMealCreation alloc] init];
        _storeSetMealCreation.name = self.storeDetailInfo.name;
        _storeSetMealCreation.pictures = self.storeDetailInfo.pictures;
        _storeSetMealCreation.recommendedReason = self.storeDetailInfo.recommendedReason;
    }
    return _storeSetMealCreation;
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
