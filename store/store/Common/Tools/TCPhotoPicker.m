//
//  TCPhotoPicker.m
//  individual
//
//  Created by 穆康 on 2016/11/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPhotoPicker.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TCPhotoPicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *pickerController;

@end

@implementation TCPhotoPicker {
    __weak TCPhotoPicker *weakSelf;
    __weak UIViewController *sourceController;
}

#pragma mark - Initialization

- (instancetype)initWithSourceController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        sourceController = controller;
        weakSelf = self;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCPhotoPicker初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Public Methods

- (void)showPhotoPikerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    switch (sourceType) {
        case UIImagePickerControllerSourceTypeCamera:
            [self showPhotoPikerWithCamera];
            break;
        case UIImagePickerControllerSourceTypePhotoLibrary:
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
            [self showPhotoPikerWithLibraryOrAlbum:sourceType];
            break;
        default:
            break;
    }
}

- (void)dismissPhotoPicker {
    if (self.pickerController) {
        [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Methods

- (void)showPhotoPikerWithCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"您的相机不可用"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [sourceController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"请您设置允许APP访问您的相机\n设置>隐私>相机"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [sourceController presentViewController:alertController animated:YES completion:nil];
    } else if (authorizationStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [weakSelf showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }];
    } else {
        [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)showPhotoPikerWithLibraryOrAlbum:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"您的相册不可用"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [sourceController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"请您设置允许APP访问您的相册\n设置>隐私>照片"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [sourceController presentViewController:alertController animated:YES completion:nil];
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [weakSelf showImagePickerControllerWithSourceType:sourceType];
            }
        }];
    } else {
        [self showImagePickerControllerWithSourceType:sourceType];
    }
}

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = sourceType;
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    pickerController.navigationBar.tintColor = TCRGBColor(42, 42, 42);
    [sourceController presentViewController:pickerController animated:YES completion:nil];
    self.pickerController = pickerController;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([self.delegate respondsToSelector:@selector(photoPicker:didFinishPickingMediaWithInfo:)]) {
        [self.delegate photoPicker:self didFinishPickingMediaWithInfo:info];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([self.delegate respondsToSelector:@selector(photoPickerDidCancel:)]) {
        [self.delegate photoPickerDidCancel:self];
    }
}

@end
