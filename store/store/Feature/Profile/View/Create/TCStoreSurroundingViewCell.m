//
//  TCStoreSurroundingViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreSurroundingViewCell.h"
#import "TCExtendButton.h"
#import "TCImageURLSynthesizer.h"
#import <UIImageView+WebCache.h>

@interface TCStoreSurroundingViewCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) TCExtendButton *deleteButton;

@end

@implementation TCStoreSurroundingViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    TCExtendButton *deleteButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"store_surrounding_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(handleClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.hitTestSlop = UIEdgeInsetsMake(-7.5, -7.5, -7.5, -7.5);
    [self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(7.5);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-7.5);
    }];
}

- (void)setPicture:(NSString *)picture {
    _picture = picture;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:picture];
    [self.imageView sd_setImageWithURL:URL placeholderImage:nil options:SDWebImageRetryFailed];
}

- (void)handleClickDeleteButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButtonInStoreSurroundingViewCell:)]) {
        [self.delegate didClickDeleteButtonInStoreSurroundingViewCell:self];
    }
}

@end
