//
//  TCIDAuthDetailViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCIDAuthStatus) {
    TCIDAuthStatusProcessing = 0,
    TCIDAuthStatusFinished
};

@interface TCIDAuthDetailViewController : TCBaseViewController

@property (nonatomic, readonly) TCIDAuthStatus authStatus;

- (instancetype)initWithIDAuthStatus:(TCIDAuthStatus)authStatus;

@end
