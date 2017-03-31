//
//  TCStoreAddressViewController.h
//  store
//
//  Created by 穆康 on 2017/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCStoreAddress.h"

typedef void(^TCEditAddressCompletion)(TCStoreAddress *storeAddress);

@interface TCStoreAddressViewController : TCBaseViewController

@property (strong, nonatomic) TCStoreAddress *storeAddress;
@property (copy, nonatomic) TCEditAddressCompletion editAddressCompletion;

@end
