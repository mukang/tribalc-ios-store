//
//  TCVerticalImageAndTitleBtn.m
//  store
//
//  Created by 王帅锋 on 2017/7/14.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCVerticalImageAndTitleBtn.h"

@interface TCVerticalImageAndTitleBtn ()

@property (copy, nonatomic) NSString *imageName;

@property (copy, nonatomic) NSString *title;

@end

@implementation TCVerticalImageAndTitleBtn

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)image title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        _imageName = image;
        _title = title;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:_imageName];
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.textColor = TCRGBColor(70, 70, 70);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.frame.size.height*21/103);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@(self.frame.size.height*28/103));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(imageView.mas_bottom).offset(self.frame.size.height*12/103);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
