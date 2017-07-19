//
//  TCStoreDetailLogoCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDetailLogoCell.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>

@interface TCStoreDetailLogoCell ()

@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation TCStoreDetailLogoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setLogo:(NSString *)logo {
    if (_logo != logo) {
        _logo = logo;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:logo];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    }
}

- (void)setUpViews {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = TCBlackColor;
    label.text = @"LOGO";
    [self.contentView addSubview:label];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 25.0;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@50);
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
