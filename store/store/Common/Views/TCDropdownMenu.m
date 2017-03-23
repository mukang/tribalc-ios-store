//
//  TCDropdownMenu.m
//  store
//
//  Created by 穆康 on 2017/2/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCDropdownMenu.h"

static CGFloat const duration = 0.25;

@interface TCDropdownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UIButton *mainButton;
@property (weak, nonatomic) UIImageView *arrowMark;
@property (strong, nonatomic) NSArray *titles;
@property (nonatomic) NSInteger rowHeight;
@property (weak, nonatomic) UIView *listView;

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
    mainButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [mainButton setTitle:@"请选择" forState:UIControlStateNormal];
    [mainButton setTitleColor:TCBlackColor forState:UIControlStateNormal];
    mainButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [mainButton addTarget:self action:@selector(handleClickMainButton:) forControlEvents:UIControlEventTouchUpInside];
    mainButton.layer.borderColor = TCSeparatorLineColor.CGColor;
    mainButton.layer.borderWidth = 0.5;
    mainButton.layer.masksToBounds = YES;
    [self addSubview:mainButton];
    self.mainButton = mainButton;
    
    UIImageView *arrowMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown_menu"]];
    [mainButton addSubview:arrowMark];
    self.arrowMark = arrowMark;
    
    [mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf);
    }];
    [arrowMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.centerY.equalTo(mainButton.mas_centerY);
        make.right.equalTo(mainButton.mas_right).with.offset(-10);
    }];
}

#pragma mark - Public Methods

- (void)setMenuTitles:(NSArray *)titles rowHeight:(CGFloat)rowHeight {
    self.titles = [NSArray arrayWithArray:titles];
    self.rowHeight = rowHeight;
    
    UIView *listView = [[UIView alloc] init];
    listView.layer.borderColor = TCSeparatorLineColor.CGColor;
    listView.layer.borderWidth = 0.5;
    listView.layer.masksToBounds = YES;
    [self.superview addSubview:listView];
    self.listView = listView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [listView addSubview:tableView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(listView);
    }];
}

- (void)showDropDown {
    [self.listView.superview bringSubviewToFront:self.listView];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuWillShow:)]) {
        [self.delegate dropdownMenuWillShow:self];
    }
    
    [weakSelf.listView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
    }];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        [weakSelf.listView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.menuIsShow = YES;
    }];
    self.mainButton.selected = YES;
}

- (void)hideDropDown {
    [weakSelf.listView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.arrowMark.transform = CGAffineTransformIdentity;
        [weakSelf.listView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.menuIsShow = NO;
    }];
    self.mainButton.selected = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = TCBlackColor;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = self.titles[indexPath.row];
    [self.mainButton setTitle:name forState:UIControlStateNormal];
    [self hideDropDown];
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectName:)]) {
        [self.delegate dropdownMenu:self didSelectName:name];
    }
}

#pragma mark - Actions

- (void)handleClickMainButton:(UIButton *)sender {
    if (sender.selected == NO) {
        [self showDropDown];
    } else {
        [self hideDropDown];
    }
}

@end
