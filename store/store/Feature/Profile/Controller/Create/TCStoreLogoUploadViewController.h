//
//  TCStoreLogoUploadViewController.h
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef void(^TCUploadLogoCompletion)(NSString *logo);

/**
 店铺logo上传
 */
@interface TCStoreLogoUploadViewController : TCBaseViewController

@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) TCUploadLogoCompletion uploadLogoCompletion;

@end
