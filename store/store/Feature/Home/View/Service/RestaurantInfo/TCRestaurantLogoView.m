//
//  TCRestaurantLogoView.m
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantLogoView.h"
#import "UIImage+Category.h"

@implementation TCRestaurantLogoView {
    UIImageView *logoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame AndUrl:(NSURL *)url {
    self = [super initWithFrame:frame];
    if (self) {

        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;

        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:logoImageView.size];
        [logoImageView sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        [self addSubview:logoImageView];
    }
    
    return self;
}

- (void)setLogoFrame:(CGRect)frame {
    
    [self setFrame:frame];
    self.layer.cornerRadius = frame.size.height / 2;
    [logoImageView setSize:CGSizeMake(self.width, self.height)];
    
}




@end
