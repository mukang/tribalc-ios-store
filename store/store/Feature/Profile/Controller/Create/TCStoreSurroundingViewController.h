//
//  TCStoreSurroundingViewController.h
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCStoreDetailInfo.h"

typedef void(^TCEditSurroundingCompletion)();

/**
 店铺环境图上传
 */
@interface TCStoreSurroundingViewController : TCBaseViewController

@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;
@property (copy, nonatomic) TCEditSurroundingCompletion editSurroundingCompletion;

@end
