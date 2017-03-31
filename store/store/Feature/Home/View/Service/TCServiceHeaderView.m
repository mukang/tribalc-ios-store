//
//  TCServiceHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/2/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceHeaderView.h"
#import "TCDetailStore.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCServiceHeaderView () <TCPicturesHeaderViewDelegate>

@property (weak, nonatomic) TCPicturesHeaderView *picturesView;
@property (weak, nonatomic) UIView *indexView;
@property (weak, nonatomic) UILabel *indexLabel;
@property (weak, nonatomic) UIView *logoBgView;
@property (weak, nonatomic) UIImageView *logoImageView;

@end

@implementation TCServiceHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCPicturesHeaderView *picturesView = [[TCPicturesHeaderView alloc] init];
    picturesView.delegate = self;
    [self addSubview:picturesView];
    self.picturesView = picturesView;
    
    UIView *indexView = [[UIView alloc] init];
    indexView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    indexView.layer.cornerRadius = 7;
    indexView.layer.masksToBounds = YES;
    indexView.hidden = YES;
    [self addSubview:indexView];
    self.indexView = indexView;
    
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.font = [UIFont systemFontOfSize:11];
    [indexView addSubview:indexLabel];
    self.indexLabel = indexLabel;
    
    UIView *logoBgView = [[UIView alloc] init];
    logoBgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.19];
    logoBgView.layer.cornerRadius = 32;
    logoBgView.layer.masksToBounds = YES;
    [self addSubview:logoBgView];
    self.logoBgView = logoBgView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    logoImageView.layer.cornerRadius = 29;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.picturesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39, 14));
        make.right.bottom.equalTo(weakSelf).offset(-8);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.indexView);
    }];
    [self.logoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(64);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.mas_bottom);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(58);
        make.center.equalTo(weakSelf.logoBgView);
    }];
}

#pragma mark - Public Methods

- (void)setDetailStore:(TCDetailStore *)detailStore {
    _detailStore = detailStore;
    
    self.picturesView.pictures = detailStore.pictures;
    
    if (self.detailStore.pictures.count > 1) {
        self.indexView.hidden = NO;
        self.indexLabel.text = [NSString stringWithFormat:@"1/%zd", detailStore.pictures.count];
    } else {
        self.indexView.hidden = YES;
    }
    
    NSURL *logoURL = [TCImageURLSynthesizer synthesizeImageURLWithPath:detailStore.logo];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(64, 64)];
    [self.logoImageView sd_setImageWithURL:logoURL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
}

#pragma mark - TCPicturesHeaderViewDelegate

- (void)picturesHeaderView:(TCPicturesHeaderView *)view didScrollToIndex:(NSInteger)index {
    if (self.detailStore.pictures.count > 1) {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", index+1, self.detailStore.pictures.count];
    }
}

@end
