//
//  TCDropdownMenu.m
//  store
//
//  Created by 穆康 on 2017/2/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCDropdownMenu.h"

@interface TCDropdownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UIButton *mainButton;
@property (weak, nonatomic) UIImageView *arrowMark;
@property (strong, nonatomic) NSArray *titles;
@property (nonatomic) NSInteger rowHeight;
@property (weak, nonatomic) UIView *listView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCDropdownMenu {
    __weak TCDropdownMenu *weakSelf;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        weakSelf = self;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [mainButton setTitle:@"请选择" forState:UIControlStateNormal];
    [mainButton setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
    mainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [mainButton addTarget:self action:@selector(handleClickMainButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mainButton];
    self.mainButton = mainButton;
    
    UIImageView *arrowMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_menu"]];
    [mainButton addSubview:arrowMark];
    self.arrowMark = arrowMark;
    
    UIView *listView = [[UIView alloc] init];
    listView.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    listView.layer.borderWidth = 0.5;
    listView.layer.masksToBounds = YES;
    [self.superview addSubview:listView];
    self.listView = listView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [listView addSubview:tableView];
    self.tableView = tableView;
    
    [mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    [arrowMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.centerY.equalTo(mainButton.mas_centerY);
        make.right.equalTo(mainButton.mas_right).with.offset(-10);
    }];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(listView);
    }];
}

- (void)setMenuTitles:(NSArray *)titles rowHeight:(CGFloat)rowHeight {
    self.titles = [NSArray arrayWithArray:titles];
    self.rowHeight = rowHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)handleClickMainButton:(UIButton *)sender {
    
}

@end
