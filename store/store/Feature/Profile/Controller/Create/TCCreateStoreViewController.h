//
//  TCCreateStoreViewController.h
//  store
//
//  Created by 穆康 on 2017/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCStoreCategoryInfo;

/**
 创建服务类型店铺
 */
@interface TCCreateStoreViewController : TCBaseViewController

@property (strong, nonatomic) TCStoreCategoryInfo *categoryInfo;

@end
