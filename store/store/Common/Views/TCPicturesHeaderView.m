//
//  TCPicturesHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/2/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPicturesHeaderView.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCPicturesHeaderView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *containerView;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation TCPicturesHeaderView {
    __weak TCPicturesHeaderView *weakSelf;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        weakSelf = self;
        self.currentIndex = -1;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;
    NSInteger imageCount = pictures.count;
    if (!imageCount) return;
    
    if (self.containerView) {
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }
    
    UIView *containerView = [[UIView alloc] init];
    [self.scrollView addSubview:containerView];
    self.containerView = containerView;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.height.equalTo(weakSelf.scrollView);
    }];
    
    UIImageView *lastImageView = nil;
    for (int i=0; i<imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = TCBackgroundColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setTag:i];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [containerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(containerView);
            make.width.mas_equalTo(TCScreenWidth);
            if (lastImageView) {
                make.left.equalTo(lastImageView.mas_right);
            } else {
                make.left.equalTo(containerView);
            }
        }];
        lastImageView = imageView;
        
        NSString *URLString = pictures[i];
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:URLString];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(115, 115)];
        [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastImageView.mas_right);
    }];
}

#pragma mark - Actions

- (void)handleTapImageView:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = TCScreenWidth;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + pageWidth * 0.5) / pageWidth;
    
    if (self.currentIndex == index) return;
    self.currentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(picturesHeaderView:didScrollToIndex:)]) {
        [self.delegate picturesHeaderView:self didScrollToIndex:self.currentIndex];
    }
}

@end
