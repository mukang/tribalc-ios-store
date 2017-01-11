//
//  TCRestaurantLogoView.h
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface TCRestaurantLogoView : UIImageView<SDWebImageManagerDelegate>

- (instancetype)initWithFrame:(CGRect)frame AndUrl:(NSURL *)url ;
- (void)setLogoFrame:(CGRect)frame;

@end
