//
//  TCStoreAuthSuccessCell.m
//  store
//
//  Created by 王帅锋 on 17/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreAuthSuccessCell.h"
#import <Masonry.h>
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

@interface TCStoreAuthSuccessCell ()

@property (strong, nonatomic) UIImageView *imageV;

@end

@implementation TCStoreAuthSuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setImageStr:(NSString *)imageStr {
    if (_imageStr != imageStr) {
        _imageStr = imageStr;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:imageStr];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:_imageV.size];
        [self.imageV sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    }
}

- (void)setUpViews {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(186, 186, 186);
    [self.contentView addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageV = imageView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(10));
        make.right.equalTo(self.contentView).offset(-(TCRealValue(10)));
        make.top.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(10));
        make.top.equalTo(lineView.mas_bottom).offset(TCRealValue(15));
        make.right.equalTo(self.contentView).offset(-(TCRealValue(10)));
        make.height.equalTo(@(TCRealValue(207)));
    }];
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
