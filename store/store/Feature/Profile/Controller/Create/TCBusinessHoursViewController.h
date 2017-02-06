//
//  TCBusinessHoursViewController.h
//  store
//
//  Created by 穆康 on 2017/2/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"

typedef void(^TCBusinessHoursBlock)(NSString *openTime, NSString *closeTime);

@interface TCBusinessHoursViewController : TCBaseViewController

@property (copy, nonatomic) NSString *openTime;
@property (copy, nonatomic) NSString *closeTime;
@property (copy, nonatomic) TCBusinessHoursBlock businessHoursBlock;

@end
