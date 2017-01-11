//
//  TCRecommendInfoViewController.h
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"
#import "TCGetNavigationItem.h"
#import "TCGoods.h"
#import "UIImageView+WebCache.h"
#import "TCBuluoApi.h"
#import "TCModelImport.h"
#import "TCGoodSelectView.h"
#import "TCClientConfig.h"
#import "TCGoodTitleView.h"
#import "NSObject+TCModel.h"
#import "TCClientRequestError.h"
#import "TCGoodShopView.h"
#import "TCImgPageControl.h"
#import "TCGoodSelectView.h"




@interface TCRecommendInfoViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SDWebImageManagerDelegate, TCGoodSelectViewDelegate>


- (instancetype)initWithGoodId:(NSString *)goodID;

@end
