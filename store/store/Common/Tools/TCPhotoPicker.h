//
//  TCPhotoPicker.h
//  individual
//
//  Created by 穆康 on 2016/11/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TCPhotoPicker;

@protocol TCPhotoPickerDelegate <NSObject>

@optional
- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker;

@end


@interface TCPhotoPicker : NSObject

@property (weak, nonatomic) id<TCPhotoPickerDelegate> delegate;

/**
 指定初始化方法，初始化完成后必须持有该对象才能进行其他操作

 @param controller 源控制器
 @return 返回TCPhotoPicker对象
 */
- (instancetype)initWithSourceController:(UIViewController *)controller;

/**
 调取拍照控制器

 @param sourceType 素材源类型
 */
- (void)showPhotoPikerWithSourceType:(UIImagePickerControllerSourceType)sourceType;

/**
 退出拍照控制器
 */
- (void)dismissPhotoPicker;

@end
