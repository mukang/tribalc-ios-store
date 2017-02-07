//
//  TCGoodsIssueViewController.m
//  store
//
//  Created by 王帅锋 on 17/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsIssueViewController.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import <Masonry.h>
#import "TCGoodsTipsCell.h"

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
    [putInStoreBtn addTarget:self action:@selector(putInStore) forControlEvents:UIControlEventTouchUpInside];
    [putInStoreBtn setBackgroundColor:[UIColor orangeColor]];
    
    UIButton *issueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [issueBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:issueBtn];
    [issueBtn addTarget:self action:@selector(issue) forControlEvents:UIControlEventTouchUpInside];
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
    _tipsCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)putInStore {
    
    
    
}

- (void)issue {
    NSArray *arr = [self.currentLibsStr componentsSeparatedByString:@"、"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
    [mutableArr addObjectsFromArray:self.selectedLibsArr];
    if (mutableArr.count > 3) {
        [MBProgressHUD showHUDWithMessage:@"选择标签和自定义标签总共最对三个"];
        return;
    }
    self.goods.tags = mutableArr;
    
    
}

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
            if (self.goods.expressType) {
                cell.textField.text = self.goods.expressType;
            }
            return cell;
        }else if (indexPath.row == 1) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"运费";
            cell.placeholder = @"请输入商品运费金额";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            
        }
    }
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.goods.expressType = textField.text;
        }else if (indexPath.row == 1) {
            self.goods.expressFee = [textField.text floatValue];
        }
    }
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