//
//  TCServiceListViewController.h
//  store
//
//  Created by 穆康 on 2017/2/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"

typedef NS_ENUM(NSInteger, TCServiceType) {
    TCServiceTypeRepast,
    TCServiceTypeOther
};

@interface TCServiceListViewController : TCBaseViewController

@property (nonatomic, readonly) TCServiceType serviceType;

- (instancetype)initWithServiceType:(TCServiceType)serviceType;

@end
