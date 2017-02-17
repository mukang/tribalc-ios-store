//
//  TCSetMainGoodView.m
//  store
//
//  Created by 王帅锋 on 17/2/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSetMainGoodView.h"
#import <Masonry.h>
#import "TCCommonButton.h"
#import "TCSetMainGoodListCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface TCSetMainGoodView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCCommonButton *cerBtn;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) UIView *topView;

@end

@implementation TCSetMainGoodView

- (instancetype)init {
    if (self = [super init]) {
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setUpUI];
    }
    return self;
}

- (void)cerClick {
    
    NSString *key = self.standards[self.currentIndexPath.row];
    
    if (self.certainBlock) {
        self.certainBlock(key);
    }
    
    if (self.deletaBlock) {
        self.deletaBlock();
    }
}

- (void)tap {
    if (self.deletaBlock) {
        self.deletaBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TCSetMainGoodListCell" configuration:^(id cell) {
        TCSetMainGoodListCell *setMainGoodListCell = cell;
        setMainGoodListCell.titleStr = self.standards[indexPath.row];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.standards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSetMainGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCSetMainGoodListCell"];
    if (!cell) {
        cell = [[TCSetMainGoodListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCSetMainGoodListCell"];
    }
    
    if (self.currentIndexPath == indexPath) {
        cell.select = YES;
    }else {
        cell.select = NO;
    }
    
    cell.titleStr = self.standards[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndexPath != indexPath) {
        self.currentIndexPath = indexPath;
        [self.tableView reloadData];
    }
    
}

- (void)setUpUI {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:self.topView];
    [self addSubview:self.tableView];
    [self addSubview:self.cerBtn];
    
    [self.cerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.cerBtn.mas_top);
        make.height.equalTo(@300);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
}

- (TCCommonButton *)cerBtn {
    if (_cerBtn == nil) {
        _cerBtn = [TCCommonButton buttonWithTitle:@"确  定" color:TCCommonButtonColorOrange target:self action:@selector(cerClick)];
    }
    return _cerBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TCSetMainGoodListCell class] forCellReuseIdentifier:@"TCSetMainGoodListCell"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 55)];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"设置主商品";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = TCRGBColor(42, 42, 42);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TCRGBColor(186, 186, 186);
        [view addSubview:lineView];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
            make.height.equalTo(@45);
        }];
        
        CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375 ? 2 : 3;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.right.equalTo(view).offset(-15);
            make.top.equalTo(label.mas_bottom);
            make.height.equalTo(@(1/scale));
        }];
        
        _tableView.tableHeaderView = view;
    }
    return _tableView;
}



@end
