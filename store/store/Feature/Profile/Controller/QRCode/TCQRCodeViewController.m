//
//  TCQRCodeViewController.m
//  individual
//
//  Created by 王帅锋 on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCQRCodeViewController.h"
#import <TCCommonLibs/UIImage+Category.h>
#import <AVFoundation/AVFoundation.h>
#import "TCScannerBorder.h"
#import "TCScannerMaskView.h"
#import "TCScanner.h"
#import "TCPhotoPicker.h"
//#import "TCPreparePayViewController.h"

/// 控件间距
#define kControlMargin  20.0
/// 相册图片最大尺寸
#define kImageMaxSize   CGSizeMake(1000, 1000)

@interface TCQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,TCPhotoPickerDelegate>
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@end

@implementation TCQRCodeViewController
{
    /// 扫描框
    TCScannerBorder *scannerBorder;
    /// 扫描器
    TCScanner *scanner;
    /// 提示标签
    UILabel *tipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNav];
    
    [self prepareScanerBorder];
    [self prepareOtherControls];
    @WeakObj(self)
    scanner = [TCScanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *stringValue) {
        @StrongObj(self)
        // 完成回调
        [self handleScanerResultWithStr:stringValue];
    }];
    
}

- (void)handleScanerResultWithStr:(NSString *)result {
//    if ([result isKindOfClass:[NSString class]]) {
//        if ([result hasPrefix:@"pay://"]) {
//            NSArray *arr = [result componentsSeparatedByString:@"://"];
//            if (arr.count > 1) {
//                NSString *storeId = arr[1];
//                TCPreparePayViewController *preparePayVC = [[TCPreparePayViewController alloc] init];
//                preparePayVC.fromController = self.fromController;
//                preparePayVC.storeId =storeId;
//                [self.navigationController pushViewController:preparePayVC animated:YES];
//                return;
//            }
//        }
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareNav {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:16],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    UIImage *image = [UIImage imageNamed:@"TransparentPixel"];
    [navBar setShadowImage:image];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"扫一扫"];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
}


- (void)torchOnFlashBtn:(UIButton *)sender{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.tag == 0) {
                
                sender.tag = 1;
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                sender.tag = 0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}



/// 点击相册按钮
- (void)clickAlbumButton {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        tipLabel.text = @"无法访问相册";
        
        return;
    }
    
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    _photoPicker = photoPicker;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

#pragma mark - TCPhotoPickerDelegate
- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [_photoPicker dismissPhotoPicker];
}

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [self resizeImage:info[UIImagePickerControllerOriginalImage]];
    
    // 扫描图像
    [TCScanner scaneImage:image completion:^(NSArray *values) {
        
        if (values.count > 0) {
            if ([values isKindOfClass:[NSArray class]] && [values.firstObject isKindOfClass:[NSString class]]) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self handleScanerResultWithStr:values.firstObject];
                }];
                
            }
        } else {
            tipLabel.text = @"没有识别到二维码，请选择其他照片";
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}



- (UIImage *)resizeImage:(UIImage *)image {
    
    if (image.size.width < kImageMaxSize.width && image.size.height < kImageMaxSize.height) {
        return image;
    }
    
    CGFloat xScale = kImageMaxSize.width / image.size.width;
    CGFloat yScale = kImageMaxSize.height / image.size.height;
    CGFloat scale = MIN(xScale, yScale);
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (void)more {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [scannerBorder startScannerAnimating];
    [scanner startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [scannerBorder stopScannerAnimating];
    [scanner stopScan];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/// 准备提示标签和名片按钮
- (void)prepareOtherControls {
    
    // 1> 提示标签
    tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = @"放入框中，即可自动扫描";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [tipLabel sizeToFit];
    tipLabel.center = CGPointMake(scannerBorder.center.x, CGRectGetMaxY(scannerBorder.frame) + kControlMargin);
    
    [self.view addSubview:tipLabel];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    [self.view addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(clickAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"flashLight"] forState:UIControlStateNormal];
    [self.view addSubview:flashBtn];
    [flashBtn addTarget:self action:@selector(torchOnFlashBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(TCRealValue(49)));
        make.width.height.equalTo(@33);
        make.centerX.equalTo(self.view).offset(-33);
    }];
    
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.height.equalTo(photoBtn);
        make.centerX.equalTo(self.view).offset(33);
    }];
}

/// 准备扫描框
- (void)prepareScanerBorder {
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/375.0;
    CGFloat width = self.view.bounds.size.width - 53*scale*2;
    scannerBorder = [[TCScannerBorder alloc] initWithFrame:CGRectMake(53*scale, 170*scale, width, width)];
    
    [self.view addSubview:scannerBorder];
    
    TCScannerMaskView *maskView = [TCScannerMaskView maskViewWithFrame:self.view.bounds cropRect:scannerBorder.frame];
    [self.view insertSubview:maskView atIndex:0];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"TCQRCodeViewController -- dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
