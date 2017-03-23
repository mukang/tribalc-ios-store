//
//  TCServiceSelectItemView.m
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceSelectItemView.h"

@interface TCServiceSelectItemView ()

@property (strong, nonatomic) NSMutableDictionary *imageMap;
@property (strong, nonatomic) NSMutableDictionary *colorMap;

@end

@implementation TCServiceSelectItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageMap = [NSMutableDictionary dictionaryWithCapacity:2];
        self.colorMap = [NSMutableDictionary dictionaryWithCapacity:2];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    self.imageView = imageView;
    self.titleLabel = titleLabel;
    
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(weakSelf).offset(20);
        make.centerX.equalTo(weakSelf);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.height.mas_equalTo(16);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(10);
    }];
}

#pragma mark - Public Methods

- (void)setImage:(UIImage *)image forState:(BOOL)isSelected {
    [self.imageMap setObject:image forKey:@(isSelected)];
    [self setSelected:self.isSelected];
}

- (void)setTitleColor:(UIColor *)color forState:(BOOL)isSelected {
    [self.colorMap setObject:color forKey:@(isSelected)];
    [self setSelected:self.isSelected];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.imageView.image = [self.imageMap objectForKey:@(selected)];
    self.titleLabel.textColor = [self.colorMap objectForKey:@(selected)];
}

@end
