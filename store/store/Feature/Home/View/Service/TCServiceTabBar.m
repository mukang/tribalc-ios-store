//
//  TCServiceTabBar.m
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceTabBar.h"
#import "TCServiceTabItemView.h"

static CGFloat const kSortViewHeight = 184;
static CGFloat const kFilterViewHeight = 108;

@interface TCServiceTabBar () <TCServiceSortViewDelegate, TCServiceFilterViewDelegate>

@property (weak, nonatomic) UIView *sortContainerView;
@property (weak, nonatomic) TCServiceTabItemView *sortItemView;
@property (weak, nonatomic) UIView *filterContainerView;
@property (weak, nonatomic) TCServiceTabItemView *filterItemView;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UIView *bottomLineView;

@property (weak, nonatomic) UIView *backgroundView;

@end

@implementation TCServiceTabBar {
    __weak TCServiceTabBar *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithController:(UIViewController *)controller {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        weakSelf = self;
        sourceController = controller;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIView *sortContainerView = [[UIView alloc] init];
    [self addSubview:sortContainerView];
    UITapGestureRecognizer *sortTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSortContainerView:)];
    [sortContainerView addGestureRecognizer:sortTap];
    
    TCServiceTabItemView *sortItemView = [[TCServiceTabItemView alloc] init];
    sortItemView.titleLabel.text = @"智能排序";
    [sortContainerView addSubview:sortItemView];
    
    UIView *filterContainerView = [[UIView alloc] init];
    [self addSubview:filterContainerView];
    UITapGestureRecognizer *filterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFilterContainerView:)];
    [filterContainerView addGestureRecognizer:filterTap];
    
    TCServiceTabItemView *filterItemView = [[TCServiceTabItemView alloc] init];
    filterItemView.titleLabel.text = @"筛选";
    [filterContainerView addSubview:filterItemView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:lineView];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:bottomLineView];
    
    TCServiceSortView *sortView = [[TCServiceSortView alloc] init];
    sortView.delegate = self;
    [sourceController.view insertSubview:sortView belowSubview:self];
    
    TCServiceFilterView *filterView = [[TCServiceFilterView alloc] init];
    filterView.delegate = self;
    [sourceController.view insertSubview:filterView belowSubview:self];
    
    [sourceController.view addSubview:self];
    
    self.sortContainerView = sortContainerView;
    self.sortItemView = sortItemView;
    self.filterContainerView = filterContainerView;
    self.filterItemView = filterItemView;
    self.lineView = lineView;
    self.bottomLineView = bottomLineView;
    self.sortView = sortView;
    self.filterView = filterView;
}

- (void)setupConstraints {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 13));
        make.center.equalTo(weakSelf);
    }];
    [self.sortContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(20);
        make.trailing.equalTo(weakSelf.lineView.mas_leading);
    }];
    [self.sortItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.sortContainerView);
    }];
    [self.filterContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.lineView.mas_trailing);
        make.trailing.equalTo(weakSelf).offset(-20);
    }];
    [self.filterItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.filterContainerView);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kSortViewHeight);
        make.top.equalTo(weakSelf.mas_bottom).offset(-kSortViewHeight);
        make.leading.trailing.equalTo(weakSelf);
    }];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kFilterViewHeight);
        make.top.equalTo(weakSelf.mas_bottom).offset(-kFilterViewHeight);
        make.leading.trailing.equalTo(weakSelf);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(sourceController.view);
        make.height.mas_equalTo(42);
    }];
}

#pragma mark - TCServiceSortViewDelegate

- (void)serviceSortView:(TCServiceSortView *)view didSelectItemViewWithSortType:(TCServiceSortType)sortType {
    if ([self.delegate respondsToSelector:@selector(serviceTabBar:didSelectItemViewWithSortType:filterType:)]) {
        [self.delegate serviceTabBar:self didSelectItemViewWithSortType:sortType filterType:self.filterView.filterType];
    }
    self.sortItemView.selected = NO;
    [self hideSortView:YES];
}

#pragma mark - TCServiceFilterViewDelegate

- (void)serviceFilterView:(TCServiceFilterView *)view didSelectItemViewWithFilterType:(TCServiceFilterType)filterType {
    if ([self.delegate respondsToSelector:@selector(serviceTabBar:didSelectItemViewWithSortType:filterType:)]) {
        [self.delegate serviceTabBar:self didSelectItemViewWithSortType:self.sortView.sortType filterType:filterType];
    }
    self.filterItemView.selected = NO;
    [self hideFilterView:YES];
}

#pragma mark - Show Select View

- (void)showSortView:(BOOL)animated {
    [self.sortView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom);
    }];
    
    if (animated) {
        [self insertBackgroundView];
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            [sourceController.view layoutIfNeeded];
        }];
    }
}

- (void)hideSortView:(BOOL)animated {
    [self.sortView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom).offset(-kSortViewHeight);
    }];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [sourceController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf.backgroundView removeFromSuperview];
        }];
    }
}

- (void)showFilterView:(BOOL)animated {
    [self.filterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom);
    }];
    
    if (animated) {
        [self insertBackgroundView];
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            [sourceController.view layoutIfNeeded];
        }];
    }
}

- (void)hideFilterView:(BOOL)animated {
    [self.filterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_bottom).offset(-kFilterViewHeight);
    }];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [sourceController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf.backgroundView removeFromSuperview];
        }];
    }
}

- (void)insertBackgroundView {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.frame = sourceController.view.bounds;
    [sourceController.view insertSubview:backgroundView belowSubview:self.sortView];
    self.backgroundView = backgroundView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBackgroundView:)];
    [backgroundView addGestureRecognizer:tap];
}

#pragma mark - Actions

- (void)handleTapSortContainerView:(UITapGestureRecognizer *)sender {
    if (self.sortItemView.isSelected) {
        self.sortItemView.selected = NO;
        [self hideSortView:YES];
    } else {
        self.sortItemView.selected = YES;
        [self showSortView:!self.filterItemView.isSelected];
    }
    if (self.filterItemView.isSelected) {
        self.filterItemView.selected = NO;
        [self hideFilterView:NO];
    }
}

- (void)handleTapFilterContainerView:(UITapGestureRecognizer *)sender {
    if (self.filterItemView.isSelected) {
        self.filterItemView.selected = NO;
        [self hideFilterView:YES];
    } else {
        self.filterItemView.selected = YES;
        [self showFilterView:!self.sortItemView.isSelected];
    }
    if (self.sortItemView.isSelected) {
        self.sortItemView.selected = NO;
        [self hideSortView:NO];
    }
}

- (void)handleTapBackgroundView:(UITapGestureRecognizer *)sender {
    if (self.sortItemView.isSelected) {
        self.sortItemView.selected = NO;
        [self hideSortView:YES];
    } else if (self.filterItemView.isSelected) {
        self.filterItemView.selected = NO;
        [self hideFilterView:YES];
    }
}

@end
