//
//  TCServiceSortView.m
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceSortView.h"
#import "TCServiceSelectItemView.h"

static NSInteger const kTagBaseNum = 10000;
static NSString *const kTitleName = @"kTitleName";
static NSString *const kImageNameNormal = @"kImageNameNormal";
static NSString *const kImageNameSelected = @"kImageNameSelected";

@interface TCServiceSortView ()

@property (weak, nonatomic) UIView *horizontalLine;
@property (weak, nonatomic) UIView *firstVerticalLine;
@property (weak, nonatomic) UIView *secondVerticalLine;

@property (strong, nonatomic) NSMutableArray *items;
@property (copy, nonatomic) NSArray *nameMaps;

@property (weak, nonatomic) TCServiceSelectItemView *currentItemView;

@end

@implementation TCServiceSortView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _sortType = TCServiceSortTypeNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    
    UIView *firstVerticalLine = [[UIView alloc] init];
    firstVerticalLine.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:firstVerticalLine];
    self.firstVerticalLine = firstVerticalLine;
    
    UIView *secondVerticalLine = [[UIView alloc] init];
    secondVerticalLine.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:secondVerticalLine];
    self.secondVerticalLine = secondVerticalLine;
    
    self.items = [NSMutableArray array];
    for (int i=0; i<self.nameMaps.count; i++) {
        NSDictionary *map = self.nameMaps[i];
        TCServiceSelectItemView *itemView = [[TCServiceSelectItemView alloc] init];
        itemView.titleLabel.text = map[kTitleName];
        [itemView setTitleColor:TCRGBColor(154, 154, 154) forState:NO];
        [itemView setTitleColor:TCRGBColor(80, 199, 209) forState:YES];
        [itemView setImage:[UIImage imageNamed:map[kImageNameNormal]] forState:NO];
        [itemView setImage:[UIImage imageNamed:map[kImageNameSelected]] forState:YES];
        [self addSubview:itemView];
        [self.items addObject:itemView];
        
        itemView.tag = kTagBaseNum + i + 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapItemView:)];
        [itemView addGestureRecognizer:tap];
    }
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.equalTo(weakSelf).offset(24);
        make.trailing.equalTo(weakSelf).offset(-24);
        make.centerY.equalTo(weakSelf);
    }];
    CGFloat horizontalLineWidth = TCScreenWidth - 48;
    [self.firstVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.equalTo(weakSelf).offset(9);
        make.bottom.equalTo(weakSelf).offset(-9);
        make.centerX.equalTo(weakSelf.horizontalLine.mas_leading).offset(horizontalLineWidth / 3);
    }];
    [self.secondVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.equalTo(weakSelf).offset(9);
        make.bottom.equalTo(weakSelf).offset(-9);
        make.centerX.equalTo(weakSelf.horizontalLine.mas_trailing).offset(-horizontalLineWidth / 3);
    }];
    [self.items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstVerticalLine);
        make.leading.equalTo(weakSelf.horizontalLine);
        make.bottom.equalTo(weakSelf.horizontalLine.mas_top);
        make.trailing.equalTo(weakSelf.firstVerticalLine.mas_leading);
    }];
    [self.items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.firstVerticalLine);
        make.leading.equalTo(weakSelf.firstVerticalLine.mas_trailing);
        make.bottom.equalTo(weakSelf.horizontalLine.mas_top);
        make.trailing.equalTo(weakSelf.secondVerticalLine.mas_leading);
    }];
    [self.items[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.secondVerticalLine);
        make.leading.equalTo(weakSelf.secondVerticalLine.mas_trailing);
        make.bottom.equalTo(weakSelf.horizontalLine.mas_top);
        make.trailing.equalTo(weakSelf.horizontalLine.mas_trailing);
    }];
    [self.items[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.horizontalLine.mas_bottom);
        make.leading.equalTo(weakSelf.horizontalLine);
        make.bottom.equalTo(weakSelf.firstVerticalLine);
        make.trailing.equalTo(weakSelf.firstVerticalLine.mas_leading);
    }];
    [self.items[4] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.horizontalLine.mas_bottom);
        make.leading.equalTo(weakSelf.firstVerticalLine.mas_trailing);
        make.bottom.equalTo(weakSelf.firstVerticalLine);
        make.trailing.equalTo(weakSelf.secondVerticalLine.mas_leading);
    }];
}

- (void)handleTapItemView:(UITapGestureRecognizer *)sender {
    TCServiceSelectItemView *itemView = (TCServiceSelectItemView *)sender.view;
    if (self.currentItemView != itemView) {
        itemView.selected = YES;
        self.currentItemView.selected = NO;
        self.currentItemView = itemView;
    }
    _sortType = itemView.tag - kTagBaseNum;
    if ([self.delegate respondsToSelector:@selector(serviceSortView:didSelectItemViewWithSortType:)]) {
        [self.delegate serviceSortView:self didSelectItemViewWithSortType:_sortType];
    }
}

#pragma mark - Override Methods

- (NSArray *)nameMaps {
    if (_nameMaps == nil) {
        _nameMaps = @[
                      @{kTitleName         : @"人均最低",
                        kImageNameNormal   : @"service_sort_per_capita_asc_normal",
                        kImageNameSelected : @"service_sort_per_capita_asc_selected"},
                      @{kTitleName         : @"人均最高",
                        kImageNameNormal   : @"service_sort_per_capita_desc_normal",
                        kImageNameSelected : @"service_sort_per_capita_desc_selected"},
                      @{kTitleName         : @"人气最高",
                        kImageNameNormal   : @"service_sort_popularity_desc_normal",
                        kImageNameSelected : @"service_sort_popularity_desc_selected"},
                      @{kTitleName         : @"离我最近",
                        kImageNameNormal   : @"service_sort_location_asc_normal",
                        kImageNameSelected : @"service_sort_location_asc_selected"},
                      @{kTitleName         : @"评价最高",
                        kImageNameNormal   : @"service_sort_evaluation_desc_normal",
                        kImageNameSelected : @"service_sort_evaluation_desc_selected"}
                      ];
    }
    return _nameMaps;
}

@end
