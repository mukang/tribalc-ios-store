//
//  TCGoodDescriptionImageCell.m
//  store
//
//  Created by 王帅锋 on 17/4/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodDescriptionImageCell.h"
#import <UIImageView+WebCache.h>
#import "TCImageURLSynthesizer.h"
#import <UIImage+Category.h>

@interface TCGoodDescriptionImageCell ()

@property (strong, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation TCGoodDescriptionImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self addSubview:self.imageV];
    [self addSubview:self.deleteBtn];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@40);
    }];
}

- (void)setUrlStr:(NSString *)urlStr {
    if (_urlStr != urlStr) {
        _urlStr = urlStr;
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:urlStr];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
        [self.imageV sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    }
}

- (void)delete {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
            [self.delegate didClickDeleteBtn:self];
        }
    }
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"standardDelete"] forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 20;
        _deleteBtn.layer.borderColor = TCGrayColor.CGColor;
        _deleteBtn.layer.borderWidth = 1.0 / (TCScreenWidth > 375 ? 3 : 2);
        _deleteBtn.clipsToBounds = YES;
        [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
