//
//  TCResaurantInfoViewController.h
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRestaurantLogoView.h"
#import "TCComponent.h"
#import "TCLocationViewController.h"
#import "TCGetNavigationItem.h"
#import "TCClientConfig.h"
#import "TCBuluoApi.h"
#import "UIImageView+WebCache.h"


@interface TCRestaurantInfoViewController : UIViewController<UIScrollViewDelegate, SDWebImageManagerDelegate>
{
    UIScrollView *mScrollView;
}

- (instancetype)initWithServiceId:(NSString *)serviceId;

@end
