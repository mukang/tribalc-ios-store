//
//  TCPhotoModeView.h
//  individual
//
//  Created by 穆康 on 2016/12/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TCPhotoModeViewDelegate;

/**
 相机选择模式视图
 */
@interface TCPhotoModeView : UIView

@property (weak, nonatomic) id<TCPhotoModeViewDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller;
- (void)show;
- (void)dismiss;

@end

@protocol TCPhotoModeViewDelegate <NSObject>

@optional
- (void)didClickCameraButtonInPhotoModeView:(TCPhotoModeView *)view;
- (void)didClickAlbumButtonInPhotoModeView:(TCPhotoModeView *)view;

@end
