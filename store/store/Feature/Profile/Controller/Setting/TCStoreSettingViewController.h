//
//  TCStoreSettingViewController.h
//  store
//
//  Created by 穆康 on 2017/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@interface TCStoreSettingViewController : TCBaseViewController

/** 从TCCreateStoreNextViewController跳转过来时应该禁止返回 */
@property (nonatomic, getter=isBackForbidden) BOOL backForbidden;

@end
