//
//  TCHomeCoverView.m
//  store
//
//  Created by 王帅锋 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeCoverView.h"

@interface TCHomeCoverView ()

@property (strong, nonatomic) UIButton *overlookBtn;

@property (strong, nonatomic) UIButton *neverBtn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TCHomeCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setRect:(CGRect)rect {
    _rect = rect;
    CGRect r = self.imageView.frame;
    if (rect.origin.y > TCScreenHeight-20-200) {
        self.imageView.image = [UIImage imageNamed:@"down"];
        r.origin.y = rect.origin.y-70;
        self.imageView.frame = r;
        [self.overlookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView).offset(TCRealValue(5));
        }];
    }else {
        self.imageView.image = [UIImage imageNamed:@"up"];
        r.origin.y = rect.origin.y+30;
        self.imageView.frame = r;
        [self.overlookBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView).offset(TCRealValue(10));
        }];
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)overlook {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOverLookMessage: currentCell:)]) {
        [self.delegate didClickOverLookMessage:self.homeMessage currentCell:self.currentCell];
    }
}

- (void)never {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickNeverShowMessage:)]) {
        [self.delegate didClickNeverShowMessage:self.homeMessage];
    }
}

- (void)setUpViews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.overlookBtn];
    [self.imageView addSubview:self.lineView];
    [self.imageView addSubview:self.neverBtn];
    [self.overlookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(5);
        make.right.equalTo(self.imageView).offset(-5);
        make.top.equalTo(self.imageView).offset(TCRealValue(10));
        make.height.equalTo(@(TCRealValue(42)));
    }];
    
    CGFloat scale = TCScreenWidth > 375 ? 3.0 : 2.0;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.overlookBtn);
        make.top.equalTo(self.overlookBtn.mas_bottom);
        make.height.equalTo(@(1/scale));
    }];
    
    [self.neverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(self.overlookBtn);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCBlackColor;
    }
    return _lineView;
}

- (UIButton *)neverBtn {
    if (_neverBtn == nil) {
        _neverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_neverBtn addTarget:self action:@selector(never) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (TCRealValue(42)-12)/2, 13, 12)];
        imageV.image = [UIImage imageNamed:@"never"];
        [_neverBtn addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, 0, 200, TCRealValue(42))];
        label.text = @"不再接受此动态";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = TCBlackColor;
        [_neverBtn addSubview:label];
    }
    return _neverBtn;
}

- (UIButton *)overlookBtn {
    if (_overlookBtn == nil) {
        _overlookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_overlookBtn addTarget:self action:@selector(overlook) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (TCRealValue(42)-12)/2, 13, 12)];
        imageV.image = [UIImage imageNamed:@"overlook"];
        [_overlookBtn addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, 0, 200, TCRealValue(42))];
        label.text = @"忽略这条动态";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = TCBlackColor;
        [_overlookBtn addSubview:label];
    }
    return _overlookBtn;
}


- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = CGRectMake((self.bounds.size.width-TCRealValue(358))/2, 0, TCRealValue(358), TCRealValue(100));
        _imageView.image = [UIImage imageNamed:@"down"];
    }
    return _imageView;
}

@end
