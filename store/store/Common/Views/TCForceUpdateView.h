//
//  TCForceUpdateView.h
//  individual
//
//  Created by 穆康 on 2017/5/31.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCAppVersion;

@protocol TCForceUpdateViewDelegate;
@interface TCForceUpdateView : UIView

@property (strong, nonatomic, readonly) TCAppVersion *versionInfo;
@property (weak, nonatomic) id<TCForceUpdateViewDelegate> delegate;

- (instancetype)initWithVersionInfo:(TCAppVersion *)versionInfo;

@end


@protocol TCForceUpdateViewDelegate <NSObject>

@optional
- (void)didClickUpdateButtonInForceUpdateView:(TCForceUpdateView *)view;

@end
