//
//  TCCreateGoodsStandardController.m
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsStandardController.h"
#import <Masonry.h>
#import "TCCreateStandardCell.h"
#import "TCCreatePriceAndRepertoryCell.h"
#import "TCCommonButton.h"
#import "TCGoodsStandardMate.h"
#import "TCBatchSetiingView.h"
#import "TCGoodsStandardDescriptions.h"
#import "TCGoodsStandardDescriptionDetail.h"
#import "TCGoodsPriceAndRepertory.h"
#import "TCSetMainGoodView.h"

@interface TCCreateGoodsStandardController ()<UITableViewDelegate,UITableViewDataSource,TCCreateStandardCellDelegate,TCCreatePriceAndRepertoryCellDelegate,TCBatchSetiingViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *cellsArr;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (copy, nonatomic) NSArray *firstGradeStandardArr;

@property (copy, nonatomic) NSArray *secondaryStandardArr;

@property (copy, nonatomic) NSArray *allStandardArr;

@property (strong, nonatomic) TCCommonButton *certailBtn;

@property (strong, nonatomic) UITextField *goodsStandardTitleTextField;

@property (assign, nonatomic) BOOL hasSecondary;

@property (assign, nonatomic) BOOL hasFirstGrade;

@property (strong, nonatomic) TCBatchSetiingView *setingView;

@property (strong, nonatomic) TCSetMainGoodView *setMainGoodView;

@property (strong, nonatomic) TCGoodsStandardMate *goodsStandardMate;

@end

@implementation TCCreateGoodsStandardController

- (instancetype)initWithGoodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate {
    if (self = [super init]) {
        if (goodsStandardMate) {
            _goodsStandardMate = goodsStandardMate;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品规格";
    _hasFirstGrade = YES;
    _hasSecondary = NO;
    [self setUpViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReload) name:@"UITableViewReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCache:) name:@"KTCUPDATESTANDARDPRICEORREPEROTY" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)tableViewReload {
    [self.tableView reloadData];
}

- (void)setUpViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0.0;
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"规格组标题";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = TCRGBColor(42, 42, 42);
    [headerView addSubview:label];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"  请输入规格组标题";
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.cornerRadius = 3.0;
    textField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    textField.layer.borderWidth = 0.5;
    [headerView addSubview:textField];
    textField.delegate = self;
    self.goodsStandardTitleTextField = textField;
    
    if (self.goodsStandardMate) {
        textField.text = self.goodsStandardMate.title;
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.top.equalTo(headerView).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@75);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.top.equalTo(headerView).offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(headerView).offset(-15);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(self.view).offset(-50);
    }];
    
    _certailBtn = [TCCommonButton buttonWithTitle:@"确 定" color:TCCommonButtonColorOrange target:self action:@selector(certail)];
    [self.view addSubview:_certailBtn];
    [_certailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self createCells];
}

- (void)certail {
    if (_goodsStandardTitleTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入规格组标题"];
        return;
    }
    
    if (_cellsArr.count == 0) {
        [MBProgressHUD showHUDWithMessage:@"请返回重新添加规格组"];
        return;
    }
    
    TCGoodsStandardMate *goodsStandardMate = [[TCGoodsStandardMate alloc] init];
    goodsStandardMate.title = _goodsStandardTitleTextField.text;
    
    TCGoodsStandardDescriptions *description = [[TCGoodsStandardDescriptions alloc] init];
    
    int j = 0;
    
    if (_hasFirstGrade) {
        j = 1;
        TCCreateStandardCell *cell = (TCCreateStandardCell *)(_cellsArr[0]);
        if (cell.standardNameTextField.text.length == 0) {
            [MBProgressHUD showHUDWithMessage:@"请输入一级规格名称"];
            return;
        }
        
        if (cell.currentStandards.count == 0) {
            [MBProgressHUD showHUDWithMessage:@"请输入一级规格"];
            return;
        }
        
        TCGoodsStandardDescriptionDetail *preDetail = [[TCGoodsStandardDescriptionDetail alloc] init];
        preDetail.label = cell.standardNameTextField.text;
        preDetail.types = cell.currentStandards;
        
        description.primary = preDetail;
    }
    
    if (_hasSecondary) {
        j = 2;
        TCCreateStandardCell *cell = (TCCreateStandardCell *)(_cellsArr[1]);
        
        if (cell.currentStandards.count && cell.standardNameTextField.text.length) {
            TCGoodsStandardDescriptionDetail *seDetail = [[TCGoodsStandardDescriptionDetail alloc] init];
            seDetail.label = cell.standardNameTextField.text;
            seDetail.types = cell.currentStandards;
            
            description.secondary = seDetail;
        }
    }
    
    goodsStandardMate.descriptions = description;
    
    NSMutableDictionary *mutabelDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int i = 0; i < self.allStandardArr.count; i++) {
        NSString *str = self.allStandardArr[i];
        int k = j;
        for (; k < _cellsArr.count; k++) {
            TCCreatePriceAndRepertoryCell *cell = (TCCreatePriceAndRepertoryCell *)(_cellsArr[k]);
            if ([cell.titleLabel.text isEqualToString:str]) {
                if (cell.orignPriceTextField.text.length && cell.salePriceTextField.text.length && cell.repertoryTextField.text.length) {
                    TCGoodsPriceAndRepertory *priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
                    priceAndRepertory.originPrice = [cell.orignPriceTextField.text doubleValue];
                    priceAndRepertory.salePrice = [cell.salePriceTextField.text doubleValue];
                    priceAndRepertory.repertory = [cell.repertoryTextField.text integerValue];
                    [mutabelDict setObject:priceAndRepertory forKey:str];
                }else {
                    [MBProgressHUD showHUDWithMessage:@"请输入完整信息"];
                    return;
                }
            }
            
        }
    }
    
    goodsStandardMate.priceAndRepertoryMap = mutabelDict;
    
//    TCSetMainGoodView *setView = [[TCSetMainGoodView alloc] init];
//    setView.standards = self.allStandardArr;
    [self.navigationController.view addSubview:self.setMainGoodView];
    @WeakObj(self)
    self.setMainGoodView.deletaBlock = ^{
        @StrongObj(self)
        [self.setMainGoodView removeFromSuperview];
        self.setMainGoodView = nil;
    };
    
    self.setMainGoodView.certainBlock =^(NSString *mainGoodStandardKey){
        @StrongObj(self)
        [self commitWith:goodsStandardMate mainGoodStandardKey:mainGoodStandardKey];
    };
    
    self.setMainGoodView.standards = self.allStandardArr;
    [self.setMainGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
}

- (void)commitWith:(TCGoodsStandardMate *)goodsStandardMate mainGoodStandardKey:(NSString *)key {
    if (self.myBlock) {
        self.myBlock(goodsStandardMate,key);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (TCSetMainGoodView *)setMainGoodView {
    if (_setMainGoodView == nil) {
        _setMainGoodView = [[TCSetMainGoodView alloc] init];
    }
    return _setMainGoodView;
}

- (void)reload {
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    if (self.secondaryStandardArr.count == 0) {
        self.allStandardArr = self.firstGradeStandardArr;
    }else if (self.firstGradeStandardArr.count == 0) {
        self.allStandardArr = self.secondaryStandardArr;
    } else {
        for (int i = 0; i < self.firstGradeStandardArr.count; i++) {
            for (int j = 0; j < self.secondaryStandardArr.count; j++) {
                NSString *str = [NSString stringWithFormat:@"%@-%@",self.firstGradeStandardArr[i],self.secondaryStandardArr[j]];
                [mutableArr addObject:str];
            }
        }
        self.allStandardArr = mutableArr;
    }
    
    NSMutableArray *mutabelCellArr = [NSMutableArray arrayWithCapacity:0];
    for (UITableViewCell *c in _cellsArr) {
        if ([c.reuseIdentifier isEqualToString:@"TCCreateStandardCell"]) {
            [mutabelCellArr addObject:c];
        }
    }
    
    for (int k = 0; k < self.allStandardArr.count; k++) {
        TCCreatePriceAndRepertoryCell *priceAndRepertyCell = [[TCCreatePriceAndRepertoryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCreatePriceAndRepertoryCell"];
        priceAndRepertyCell.delegate = self;
        priceAndRepertyCell.titleLabel.text = self.allStandardArr[k];
        
        if (self.goodsStandardMate) {
            if (self.goodsStandardMate.priceAndRepertoryMap) {
                for (int l = 0; l < self.goodsStandardMate.priceAndRepertoryMap.allKeys.count; l++) {
                    NSString *key = self.goodsStandardMate.priceAndRepertoryMap.allKeys[l];
                    if ([key isEqualToString:priceAndRepertyCell.titleLabel.text]) {
                        TCGoodsPriceAndRepertory *priceAndReperoty = self.goodsStandardMate.priceAndRepertoryMap[key];
                        priceAndRepertyCell.orignPriceTextField.text = [NSString stringWithFormat:@"%.2f",priceAndReperoty.originPrice];
                        priceAndRepertyCell.salePriceTextField.text = [NSString stringWithFormat:@"%.2f",priceAndReperoty.salePrice];
                        priceAndRepertyCell.repertoryTextField.text = [NSString stringWithFormat:@"%ld",priceAndReperoty.repertory];
                    }
                }
            }
        }
        
        [mutabelCellArr addObject:priceAndRepertyCell];
    }
    
    self.cellsArr = mutabelCellArr;
    [self.tableView reloadData];
}

- (void)createCells {
    TCCreateStandardCell *cell = [[TCCreateStandardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCreateStandardCell"];
    cell.titleLabel.text = @"一级规格";
//    cell.isNeedAdd = YES;
    cell.delegate = self;
    _cellsArr = [NSArray arrayWithObject:cell];
    
    if (self.goodsStandardMate) {
        if (self.goodsStandardMate.descriptions) {
            if (self.goodsStandardMate.descriptions.primary) {
                cell.standardNameTextField.text = self.goodsStandardMate.descriptions.primary.label;
                self.firstGradeStandardArr = self.goodsStandardMate.descriptions.primary.types;
                cell.currentStandards = self.goodsStandardMate.descriptions.primary.types;
            }
        }
    }
    
    if (self.goodsStandardMate.descriptions.secondary) {
        [self addSecondaryStandardCell];
    }
    
}

- (void)batchSeting {
    if (_setingView == nil) {
        _setingView = [[TCBatchSetiingView alloc] init];
        _setingView.delegate = self;
        [self.navigationController.view addSubview:_setingView];
        @WeakObj(self)
        _setingView.deleteBlock = ^{
            @StrongObj(self)
            [self deleteSetingView];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSetingView)];
        [_setingView addGestureRecognizer:tap];
        
        [_setingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }
}

- (void)deleteSetingView {
    if (_setingView) {
        [_setingView removeFromSuperview];
        _setingView = nil;
    }
}


#pragma mark TCCreatePriceAndRepertoryCellDelegate

- (void)deleteCurrentStandard:(UITableViewCell *)cell {
    if (cell) {
        NSMutableArray *mutabelArr = [NSMutableArray arrayWithArray:_cellsArr];
        [mutabelArr removeObject:cell];
        _cellsArr = mutabelArr;
        
        TCCreatePriceAndRepertoryCell *ce = (TCCreatePriceAndRepertoryCell *)cell;
        NSString *str = ce.titleLabel.text;
        NSMutableArray *mutableStrArr = [NSMutableArray arrayWithArray:self.allStandardArr];
        [mutableStrArr removeObject:str];
        self.allStandardArr = mutableStrArr;
        [self.tableView reloadData];
    }
}

- (void)textFieldDidEndEditting:(NSDictionary *)dict {
    if (!dict)
        return;
    
    NSString *key = dict.allKeys[0];
    
    if (!self.goodsStandardMate) {
        self.goodsStandardMate = [[TCGoodsStandardMate alloc] init];
    }
    
    if (!self.goodsStandardMate.priceAndRepertoryMap) {
        self.goodsStandardMate.priceAndRepertoryMap = [NSDictionary dictionary];
    }
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.goodsStandardMate.priceAndRepertoryMap];
    TCGoodsPriceAndRepertory *priceAndRepertory = self.goodsStandardMate.priceAndRepertoryMap[key];
    if (!priceAndRepertory) {
        priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
    }
    
    NSDictionary *dic = dict[key];
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *subKey = dic.allKeys[0];
        
        if ([subKey isEqualToString:@"originPrice"]) {
            priceAndRepertory.originPrice = [dic[subKey] doubleValue];
        }else if ([subKey isEqualToString:@"salePrice"]) {
            priceAndRepertory.salePrice = [dic[subKey] doubleValue];
        }else {
            priceAndRepertory.repertory = [dic[subKey] integerValue];
        }
    }
    
    [mutableDic setObject:priceAndRepertory forKey:key];
    
    self.goodsStandardMate.priceAndRepertoryMap = mutableDic;
}


#pragma mark TCCreateStandardCellDelegate

- (void)createOrReloadPriceAndRepertoryCell:(UITableViewCell *)cell {
    if (cell) {
        TCCreateStandardCell *createCell = (TCCreateStandardCell *)cell;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:createCell];
        if (indexPath.section == 0) {
            self.firstGradeStandardArr = createCell.currentStandards;
        }else if (indexPath.section == 1) {
            self.secondaryStandardArr = createCell.currentStandards;
        }
        
        [self reload];
    }
}

- (void)deleteCurrentCell:(UITableViewCell *)cell {
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:_cellsArr];
    [mutableArr removeObject:cell];
    
    _cellsArr = mutableArr;
    if (_cellsArr.count > 0) {
        
        if ([_cellsArr[0] isKindOfClass:[TCCreateStandardCell class]]) {
            TCCreateStandardCell *createCell = _cellsArr[0];
            createCell.titleLabel.text = @"一级规格";
            [createCell showAddBtn];
        }
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        self.firstGradeStandardArr = self.secondaryStandardArr;
        self.secondaryStandardArr = nil;
    }else if (indexPath.section == 1) {
        self.secondaryStandardArr = nil;
    }
    
    self.hasSecondary = NO;
    
    [self reload];
}

- (void)addSecondaryStandardCell {
    TCCreateStandardCell *secondaryCell = [[TCCreateStandardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCreateStandardCell"];
    secondaryCell.titleLabel.text = @"二级规格";
    secondaryCell.delegate = self;
    if (self.goodsStandardMate) {
        if (self.goodsStandardMate.descriptions) {
            if (self.goodsStandardMate.descriptions.secondary) {
                secondaryCell.standardNameTextField.text = self.goodsStandardMate.descriptions.secondary.label;
                self.secondaryStandardArr = self.goodsStandardMate.descriptions.secondary.types;
                secondaryCell.currentStandards = self.goodsStandardMate.descriptions.secondary.types;
            }
        }
    }
    
    
    //    secondaryCell.isNeedAdd = NO;
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:_cellsArr];
    [mutableArr insertObject:secondaryCell atIndex:1];
    //    [mutableArr addObject:secondaryCell];
    
    _cellsArr = mutableArr;
    
    for (UITableViewCell *cell  in _cellsArr) {
        if ([cell isKindOfClass:[TCCreateStandardCell class]]) {
            [(TCCreateStandardCell *)cell hideAddBtn];
        }
        
    }
    _hasSecondary = YES;
    [self tableViewReload];
}


- (void)textFieldShouldReturnn {
    [self.view endEditing:YES];
}

- (void)textFieldShouldEndEditting:(UITableViewCell *)cell {
    self.currentIndexPath = nil;
}

- (void)textFieldShouldBeginEditting:(UITableViewCell *)cell {
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self.currentIndexPath = indexPath;
    }
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
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height - 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height - 49, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}


- (void)updateCache:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    NSString *price = dic[@"price"];
    NSString *repertory = dic[@"repertory"];
    
    if (!self.goodsStandardMate) {
        self.goodsStandardMate = [[TCGoodsStandardMate alloc] init];
    }
    
    if (!self.goodsStandardMate.priceAndRepertoryMap) {
        self.goodsStandardMate.priceAndRepertoryMap = [NSDictionary dictionary];
    }
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.goodsStandardMate.priceAndRepertoryMap];
    for (int i = 0; i < self.allStandardArr.count; i++) {
        NSString *standardStr = self.allStandardArr[i];
        TCGoodsPriceAndRepertory *priceAndRepertory = self.goodsStandardMate.priceAndRepertoryMap[standardStr];
        if (!priceAndRepertory) {
            priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
        }
        if ([price isKindOfClass:[NSString class]]) {
            priceAndRepertory.salePrice = [price doubleValue];
        }
        
        if ([repertory isKindOfClass:[NSString class]]) {
            priceAndRepertory.repertory = [repertory integerValue];
        }
        
        [mutableDic setObject:priceAndRepertory forKey:standardStr];
    }
    
    self.goodsStandardMate.priceAndRepertoryMap = mutableDic;
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellsArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellsArr[indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellsArr[indexPath.section] cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] init];
    UIButton *setingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setingBtn setTitle:@" 批量设置" forState:UIControlStateNormal];
    setingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [setingBtn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
    [setingBtn setImage:[UIImage imageNamed:@"batchSeting"] forState:UIControlStateNormal];
    [setingBtn addTarget:self action:@selector(batchSeting) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:setingBtn];
    
    [setingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sectionHeaderView).offset(-15);
        make.top.bottom.equalTo(sectionHeaderView);
        make.width.equalTo(@80);
    }];
    
    if (_hasSecondary) {
        if (section == 2) {
            return sectionHeaderView;
        }else {
            return nil;
        }
    }else {
        if (section == 1) {
            return sectionHeaderView;
        }else {
            return nil;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_hasSecondary) {
        if (section == 2) {
            return 30.0;
        }else {
            return 9.0;
        }
    }else {
        if (section == 1) {
            return 30.0;
        }else {
            return 9.0;
        }
    }
}

#pragma mark UITTextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)dealloc {
    NSLog(@"---- TCCreateGoodsStandardController ----");
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
