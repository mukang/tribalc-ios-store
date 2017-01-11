//
//  TCRestaurantViewController.h
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TCServiceFilterView.h"
#import "TCRestaurantTableViewCell.h"
#import "TCRestaurantInfoViewController.h"
#import "TCGetNavigationItem.h"
#import "TCRestaurantSortView.h"
#import "TCRestaurantFilterView.h"
#import "TCLocationViewController.h"
#import "TCBuluoApi.h"
#import "TCModelImport.h"
#import "TCClientConfig.h"
#import "UIImageView+WebCache.h"
#import "TCRecommendFooter.h"
#import "TCRecommendHeader.h"
#import "MJRefresh.h"

@interface TCRestaurantViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, SDWebImageManagerDelegate, CLLocationManagerDelegate, TCServiceFilterViewDelegate>{
    UITableView *mResaurantTableView;
}
@end
