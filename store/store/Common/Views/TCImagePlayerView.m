//
//  TCImagePlayerView.m
//  individual
//
//  Created by 穆康 on 2016/12/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCImagePlayerView.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSInteger const plusNum = 2;  // 需要加上的数

@interface TCImagePlayerView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, getter=isPlayEnabled) BOOL playEnabled;

@property (strong, nonatomic) NSArray *pictures;
@end

@implementation TCImagePlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    [self removeTimer];
}

- (void)setupSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPage = 0;
//    pageControl.centerX = self.width * 0.5;
//    pageControl.centerY = self.height - 15;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).offset(-15);
    }];
    
    self.playEnabled = YES;
}


- (void)setPictures:(NSArray *)pictures isLocal:(BOOL)isLocal{
    _pictures = pictures;
    
    NSInteger imageCount = pictures.count;
    
    if (!imageCount) return;
    
    if (imageCount == 1) {
        self.playEnabled = NO;
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.bounces = NO;
        self.pageControl.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setTag:0];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:imageView];
        if (isLocal) {
            imageView.image = [UIImage imageNamed:pictures[0]];
        }else {
            NSString *URLString = pictures[0];
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:URLString];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:imageView.size];
            [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        }
        return;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * (imageCount + plusNum), 0);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
    self.pageControl.numberOfPages = imageCount;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden = NO;
    
    for (int i=0; i<imageCount + plusNum; i++) {
        CGFloat imageW = self.scrollView.width;
        CGFloat imageH = self.scrollView.height;
        CGFloat imageX = imageW * i;
        NSInteger imageIndex;
        if (i == 0) {
            imageIndex = imageCount - 1;
        } else if (i == imageCount + 1) {
            imageIndex = 0;
        } else {
            imageIndex = i - 1;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setTag:imageIndex];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:imageView];
        
        if (isLocal) {
            imageView.image = [UIImage imageNamed:pictures[imageIndex]];
        }else {
            NSString *URLString = pictures[imageIndex];
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:URLString];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:imageView.size];
            [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        }
    }
}


#pragma mark - Public Methods

- (void)hidePageControl {
    self.pageControl.hidden = YES;
}

- (void)startPlaying {
    if (!self.isPlayEnabled) return;
    
    if (!self.timer) {
        [self addTimer];
    }
}

- (void)stopPlaying {
    if (!self.isPlayEnabled) return;
    
    [self removeTimer];
}

#pragma mark - Timer

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Actions

- (void)nextImage {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.width;
    
    if (currentPage == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * imageCount, 0) animated:NO];
        currentPage = imageCount - 1;
    } else if (currentPage == imageCount + 1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
        currentPage = 1;
    }
    
    currentPage ++;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * currentPage, 0) animated:YES];
}

- (void)handleTapImageView:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.width;
    
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.width * imageCount, 0) animated:NO];
        self.pageControl.currentPage = imageCount - 1;
    } else if (currentPage == imageCount + 1) {
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:NO];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.width;
    
    if (currentPage == imageCount + 1) {
        currentPage = 1;
    }
    
    self.pageControl.currentPage = currentPage - 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopPlaying];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self startPlaying];
}

@end
