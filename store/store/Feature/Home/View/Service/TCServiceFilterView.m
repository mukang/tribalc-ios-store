//
//  TCServiceFilterView.m
//  store
//
//  Created by 穆康 on 2017/3/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceFilterView.h"
#import "TCServiceSelectItemView.h"

static NSInteger const kTagBaseNum = 20000;
static NSString *const kTitleName = @"kTitleName";
static NSString *const kImageNameNormal = @"kImageNameNormal";
static NSString *const kImageNameSelected = @"kImageNameSelected";

@interface TCServiceFilterView ()

@property (weak, nonatomic) UIView *firstVerticalLine;
@property (weak, nonatomic) UIView *secondVerticalLine;

@property (strong, nonatomic) NSMutableArray *items;
@property (copy, nonatomic) NSArray *nameMaps;

@property (weak, nonatomic) TCServiceSelectItemView *currentItemView;

@end

@implementation TCServiceFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _filterType = TCServiceFilterTypeNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
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
    CGFloat padding = 24;
    CGFloat totalWidth = TCScreenWidth - padding * 2.0;
    [self.firstVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.equalTo(weakSelf).offset(9);
        make.bottom.equalTo(weakSelf).offset(-9);
        make.centerX.equalTo(weakSelf.mas_leading).offset(totalWidth / 3.0 + padding);
    }];
    [self.secondVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.equalTo(weakSelf).offset(9);
        make.bottom.equalTo(weakSelf).offset(-9);
        make.centerX.equalTo(weakSelf.mas_trailing).offset(-(totalWidth / 3.0 + padding));
    }];
    [self.items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.firstVerticalLine);
        make.leading.equalTo(weakSelf).offset(padding);
        make.trailing.equalTo(weakSelf.firstVerticalLine.mas_leading);
    }];
    [self.items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.firstVerticalLine);
        make.leading.equalTo(weakSelf.firstVerticalLine.mas_trailing);
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
    _filterType = itemView.tag - kTagBaseNum;
    if ([self.delegate respondsToSelector:@selector(serviceFilterView:didSelectItemViewWithFilterType:)]) {
        [self.delegate serviceFilterView:self didSelectItemViewWithFilterType:_filterType];
    }
}

#pragma mark - Override Methods

- (NSArray *)nameMaps {
    if (_nameMaps == nil) {
        _nameMaps = @[
                      @{kTitleName         : @"可预订",
                        kImageNameNormal   : @"service_filter_reservation_normal",
                        kImageNameSelected : @"service_filter_reservation_selected"},
                      @{kTitleName         : @"有包间",
                        kImageNameNormal   : @"service_filter_home_normal",
                        kImageNameSelected : @"service_filter_home_selected"}
                      ];
    }
    return _nameMaps;
}

@end
