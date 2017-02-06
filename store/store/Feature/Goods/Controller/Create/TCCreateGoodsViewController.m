//
//  TCCreateGoodsViewController.m
//  store
//
//  Created by 王帅锋 on 17/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsViewController.h"
#import "TCCommonButton.h"
#import "TCGoodsDetailTitleCell.h"
#import "TCCommonInputViewCell.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCCommonIndicatorViewCell.h"
#import <YYText.h>
#import "TCCreateGoodsStandardController.h"
#import "TCGoodsIssueViewController.h"

@interface TCCreateGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,TCCommonInputViewCellDelegate,YYTextViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCCommonButton *nextBtn;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) TCGoodsStandardMate *currentGoodsStandardMate;

@end

@implementation TCCreateGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布商品";
 
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0.01;
    _tableView.sectionHeaderHeight = 9.0;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(250))];
    _tableView.tableHeaderView = headView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"chosePhoto"] forState:UIControlStateNormal];
    [headView addSubview:btn];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [headView addSubview:imageView];
    
    _nextBtn = [TCCommonButton bottomButtonWithTitle:@"下一步" color:TCCommonButtonColorOrange target:self action:@selector(next)];
    [self.view addSubview:_nextBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TCRealValue(50));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headView);
        make.width.equalTo(@(TCRealValue(62)));
        make.height.equalTo(@(TCRealValue(54)));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else {
            return 45;
        }
    }else {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        if (self.currentGoodsStandardMate) {
            return 3;
        }
        return 6;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCGoodsDetailTitleCell *cell = [[TCGoodsDetailTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsDetailTitleCell"];
            cell.textView.delegate = self;
            if ([self.goods.title isKindOfClass:[NSString class]]) {
                cell.textView.text = self.goods.title;
            }
            return cell;
        }else {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.delegate = self;
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"列表标题";
                cell.placeholder = @"例：现货包邮MAC魅可VIVA GLAM限量版";
                if ([self.goods.name isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.name;
                }
            }else if (indexPath.row == 2) {
                cell.titleLabel.text = @"简短说明";
                cell.placeholder = @"请用一句话概括商品";
                if ([self.goods.note isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.note;
                }
            }
            return cell;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TCCommonSubtitleViewCell *cell = [[TCCommonSubtitleViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonSubtitleViewCell"];
            cell.titleLabel.text = @"类别";
            cell.subtitleLabel.text = [NSString stringWithFormat:@"商品>%@",self.goods.category];
            return cell;
        }else if (indexPath.row == 1) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.titleLabel.text = @"品牌";
            cell.placeholder = @"请输入商品品牌";
            cell.delegate = self;
            if ([self.goods.brand isKindOfClass:[NSString class]]) {
                cell.textField.text = self.goods.brand;
            }
            return cell;
        }else if (indexPath.row == 2) {
            TCCommonIndicatorViewCell *cell = [[TCCommonIndicatorViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonIndicatorViewCell"];
            cell.titleLabel.text = @"规格";
            cell.subtitleLabel.text = @"请输入商品规格";
            if (self.currentGoodsStandardMate) {
                cell.subtitleLabel.text = self.currentGoodsStandardMate.title;
            }
            return cell;
        }else if (indexPath.row == 3) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.titleLabel.text = @"销售价格";
            cell.placeholder = @"请输入商品销售价格";
            cell.delegate = self;
            
            if (self.goods.goodsPriceAndRepertory.salePrice) {
                cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.goodsPriceAndRepertory.salePrice];
            }
            
            return cell;
        }else if (indexPath.row == 4) {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.titleLabel.text = @"原始价格";
            cell.placeholder = @"请输入商品原始价格";
            cell.delegate = self;
            if (self.goods.goodsPriceAndRepertory.originPrice) {
                cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.goodsPriceAndRepertory.originPrice];
            }
            return cell;
        }else {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.titleLabel.text = @"库存量";
            cell.placeholder = @"请输入商品库存量";
            cell.delegate = self;
            if (self.goods.goodsPriceAndRepertory.repertory) {
                cell.textField.text = [NSString stringWithFormat:@"%ld",self.goods.goodsPriceAndRepertory.repertory];
            }
            return cell;
        }
    }else {
        TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
        cell.titleLabel.text = @"原产国";
        cell.placeholder = @"请输入商品原产国";
        cell.delegate = self;
        if ([self.goods.originCountry isKindOfClass:[NSString class]]) {
            cell.textField.text = self.goods.originCountry;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            TCCreateGoodsStandardController *createVc = [[TCCreateGoodsStandardController alloc] init];
            if (self.currentGoodsStandardMate) {
                createVc.goodsStandardMate = self.currentGoodsStandardMate;
            }
            @WeakObj(self)
            createVc.myBlock = ^(TCGoodsStandardMate *goodsStandardMate){
                @StrongObj(self)
                self.currentGoodsStandardMate = goodsStandardMate;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:createVc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.currentIndexPath = indexPath;
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            self.goods.name = textField.text;
        }else if (indexPath.row == 2) {
            self.goods.note = textField.text;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            self.goods.brand = textField.text;
        }else if (indexPath.row == 3) {
            self.goods.goodsPriceAndRepertory.salePrice = [textField.text floatValue];
        }else if (indexPath.row == 4) {
            self.goods.goodsPriceAndRepertory.originPrice = [textField.text floatValue];
        }else if (indexPath.row == 5) {
            self.goods.goodsPriceAndRepertory.repertory = [textField.text integerValue];
        }
    }else {
        self.goods.originCountry = textField.text;
    }
}

#pragma mark - YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"/n"]) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.currentIndexPath = nil;
    self.goods.title = textView.text;
//    self.storeDetailInfo.recommendedReason = textView.text;
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
//    if (self.currentIndexPath.section != 3 || self.currentIndexPath.row != 0) return;
    
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

- (void)next {
    TCGoodsIssueViewController *issueVC = [[TCGoodsIssueViewController alloc] init];
    issueVC.goods = self.goods;
    if (self.currentGoodsStandardMate) {
        issueVC.goodsStandardMate = self.currentGoodsStandardMate;
    }
    [self.navigationController pushViewController:issueVC animated:YES];
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
