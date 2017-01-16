//
//  TCQRCodeViewController.m
//  individual
//
//  Created by 王帅锋 on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCQRCodeViewController.h"
#import "UIImage+Category.h"
#import <AVFoundation/AVFoundation.h>
#import "TCScannerBorder.h"
#import "TCScannerMaskView.h"
#import "TCScanner.h"
#import "TCPhotoPicker.h"

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
    self.title = @"扫一扫";

    self.navigationController.navigationBar.translucent = YES;
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(255, 255, 255, 0.01)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self prepareNav];
    
    [self prepareScanerBorder];
    [self prepareOtherControls];
    @WeakObj(self)
    scanner = [TCScanner scanerWithView:self.view scanFrame:scannerBorder.frame completion:^(NSString *stringValue) {
        @StrongObj(self)
        // 完成回调
//        self.completion();
        [MBProgressHUD showHUDWithMessage:@"此功能暂未开放，敬请期待！"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
   
}


- (void)prepareNav {
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0,0,115,30)];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"qrPhotos"] forState:UIControlStateNormal];
//    [photoBtn setImage:[UIImage imageNamed:@"qrPhotos"] forState:UIControlStateNormal];
    photoBtn.frame = CGRectMake(15, 0, 30, 30);
    [rightView addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(clickAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [flashBtn setImage:[UIImage imageNamed:@"qrFlashLight"] forState:UIControlStateNormal];
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"qrFlashLight"] forState:UIControlStateNormal];
    flashBtn.frame = CGRectMake(50, 0, 30, 30);
    [rightView addSubview:flashBtn];
    [flashBtn addTarget:self action:@selector(torchOnFlashBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [moreBtn setImage:[UIImage imageNamed:@"qrMore"] forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"qrMore"] forState:UIControlStateNormal];

    moreBtn.frame = CGRectMake(85, 0, 30, 30);
    [rightView addSubview:moreBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
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
            //            self.completionCallBack(values.firstObject);
            [self dismissViewControllerAnimated:NO completion:^{
                //                [self clickCloseButton];
            }];
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
    self.navigationController.navigationBar.translucent = NO;

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
    
    // 2> 名片按钮
    UIButton *cardButton = [[UIButton alloc] init];
    
    [cardButton setTitle:@"我的二维码" forState:UIControlStateNormal];
    cardButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [cardButton setTitleColor:TCRGBColor(88, 191, 200) forState:UIControlStateNormal];
    
    [cardButton sizeToFit];
    cardButton.center = CGPointMake(tipLabel.center.x, CGRectGetMaxY(tipLabel.frame) + kControlMargin);
    
    [self.view addSubview:cardButton];
    
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
