//
//  TCStoreDetailPicturesCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDetailPicturesCell.h"
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>

@interface TCStoreDetailPicturesCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TCStoreDetailPicturesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setPictures:(NSArray *)pictures {
    if (_pictures != pictures) {
        _pictures = pictures;
        
        if ([pictures isKindOfClass:[NSArray class]]) {
            CGFloat currentX = 0.0;
            for (int i = 0; i < pictures.count; i++) {
                NSString *str = pictures[i];
                if ([str isKindOfClass:[NSString class]]) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentX, 0, 133, 100)];
                    [self.scrollView addSubview:imageView];
                    NSURL *imageUrl = [TCImageURLSynthesizer synthesizeImageURLWithPath:str];
                    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(133, 100)];
                    [imageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage options:SDWebImageRetryFailed];
                    currentX += 138;
                    
                }
            }
            self.scrollView.contentSize = CGSizeMake(currentX-5, 0);
        }
    }
}

- (void)setUpViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.scrollView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@45);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@100);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"介    绍";
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
