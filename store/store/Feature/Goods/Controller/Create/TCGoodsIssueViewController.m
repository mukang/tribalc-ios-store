//
//  TCGoodsIssueViewController.m
//  store
//
//  Created by 王帅锋 on 17/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsIssueViewController.h"
#import "TCCommonInputViewCell.h"
#import <TCCommonLibs/TCCommonIndicatorViewCell.h>
#import <Masonry.h>
#import "TCGoodsTipsCell.h"
#import "TCBuluoApi.h"
#import "TCGoodDescriptionViewController.h"
#import "TCStoreViewController.h"

@interface TCGoodsIssueViewController ()<UITableViewDelegate,UITableViewDataSource,TCCommonInputViewCellDelegate,TCGoodsTipsCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCGoodsTipsCell *tipsCell;

@property (copy, nonatomic) NSArray *selectedLibsArr;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (copy, nonatomic) NSString *currentLibsStr;

@end

@implementation TCGoodsIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)setUpViews {
    self.title = @"发布商品";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    tableView.sectionHeaderHeight = 0.0;
    tableView.sectionFooterHeight = 10.0;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    UIButton *putInStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [putInStoreBtn setTitle:@"放入仓库" forState:UIControlStateNormal];
    [putInStoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:putInStoreBtn];
    putInStoreBtn.tag = 123;
    [putInStoreBtn addTarget:self action:@selector(issue:) forControlEvents:UIControlEventTouchUpInside];
    [putInStoreBtn setBackgroundColor:[UIColor orangeColor]];
    
    UIButton *issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [issueBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:issueBtn];
    issueBtn.tag = 124;
    [issueBtn addTarget:self action:@selector(issue:) forControlEvents:UIControlEventTouchUpInside];
    [issueBtn setBackgroundColor:[UIColor redColor]];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(putInStoreBtn.mas_top);
    }];
    
    [putInStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.equalTo(@50);
        make.width.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(putInStoreBtn);
        make.left.equalTo(putInStoreBtn.mas_right);
    }];
    
    _tipsCell = [[TCGoodsTipsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsTipsCell"];
    _tipsCell.type = self.goods.category;
    _tipsCell.delegate = self;
    if ([self.goods.tags isKindOfClass:[NSArray class]]) {
        if (self.goods.tags.count) {
            _tipsCell.libsArr = self.goods.tags;
        }
    }
    _tipsCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)issue:(UIButton *)btn {
    
    [MBProgressHUD showHUD:YES];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    if (self.currentLibsStr) {
        if (self.currentLibsStr.length) {
            NSArray *arr = [self.currentLibsStr componentsSeparatedByString:@"、"];
            [mutableArr addObjectsFromArray:arr];
        }
    }
    
    if (self.selectedLibsArr) {
        [mutableArr addObjectsFromArray:self.selectedLibsArr];
    }
    
    if (mutableArr.count > 3) {
        [MBProgressHUD showHUDWithMessage:@"选择标签和自定义标签总共最对三个"];
        return;
    }
    
    if (mutableArr.count) {
        self.goods.tags = mutableArr;
    }
    
    if (btn.tag == 123) {
        self.goods.published = NO;
    }else {
        self.goods.published = YES;
    }
    
    TCGoodsStandardMate *goodStandMate = self.goodsStandardMate;
    
    if (self.goods.standardId || self.goods.priceAndRepertory) {
        goodStandMate = nil;
    }
    
    if (self.goods.ID) {
        
        [[TCBuluoApi api] modifyGoods:self.goods result:^(BOOL success, NSError *error) {
            if (success) {
                [MBProgressHUD hideHUD:YES];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                TCStoreViewController *storeVC = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:storeVC animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KISSUEORMODIFYGOODS" object:nil];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
            }
        }];
    }else {
        [[TCBuluoApi api] createGoods:self.goods goodsStandardMate:goodStandMate mainGoodsStandardKey:self.mainGoodsStandardKey result:^(NSArray *goodsArr, NSError *error) {
            if (goodsArr) {
                [MBProgressHUD hideHUD:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KISSUEORMODIFYGOODS" object:nil];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                TCStoreViewController *storeVC = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:storeVC animated:YES];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
            }
            
        }];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }else {
        return [_tipsCell cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"货号";
            cell.placeholder = @"请输入商品货号";
            if (self.goods.number) {
                cell.textField.text = self.goods.number;
            }
            return cell;
        }else if (indexPath.row == 1) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"运费";
            cell.placeholder = @"请输入商品运费金额";
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            if (self.goods.expressFee) {
                cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.expressFee];
            }
            return cell;
        }else {
            TCCommonIndicatorViewCell *cell = [[TCCommonIndicatorViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonIndicatorViewCell"];
            cell.titleLabel.text = @"商品描述";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else {
        return _tipsCell;
    }
}

#pragma mark UITabelViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            TCGoodDescriptionViewController *goodDesVC = [[TCGoodDescriptionViewController alloc] init];
            goodDesVC.doneBlock = ^(NSArray *arr){
                if ([arr isKindOfClass:[NSArray class]]) {
                    if (arr.count > 0) {
                        self.goods.detail = arr;
                    }
                }
            };
            if ([self.goods.detail isKindOfClass:[NSArray class]]) {
                if (self.goods.detail.count > 0) {
                    goodDesVC.urlArr = self.goods.detail;
                }
            }
            [self.navigationController pushViewController:goodDesVC animated:YES];
        }
    }
}

#pragma mark TCCommonInputViewCellDelegate

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.goods.number = textField.text;
        }else if (indexPath.row == 1) {
            self.goods.expressFee = [textField.text doubleValue];
        }
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma TCGoodsTipsCellDelegate
- (void)didSelectedLib:(NSArray *)arr {
    self.selectedLibsArr = arr;
}

- (void)textFieldDidEndEditting:(UITextField *)field {
    self.currentIndexPath = nil;
    self.currentLibsStr = field.text;
}

- (void)textFieldShouldBeginEditting:(UITextField *)field {
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentIndexPath.section != 1 || self.currentIndexPath.row != 0) return;
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height - 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height - 49, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)dealloc {
    NSLog(@"------ TCGoodsIssueViewController ------");
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
