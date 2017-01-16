//
//  TCSettingCacheViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSettingCacheViewCell.h"
#import <Masonry.h>
#import <SDImageCache.h>

@interface TCSettingCacheViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCSettingCacheViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"清除缓存";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = [NSString stringWithFormat:@"%.2fM",tmpSize];
    subtitleLabel.textAlignment = NSTextAlignmentRight;
    subtitleLabel.textColor = TCRGBColor(42, 42, 42);
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.width.mas_equalTo(100);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.width.mas_equalTo(150);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [MBProgressHUD showHUD:YES];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [MBProgressHUD showHUDWithMessage:@"缓存已清除"];
        self.subtitleLabel.text = @"0.00M";
    }];
}

@end
