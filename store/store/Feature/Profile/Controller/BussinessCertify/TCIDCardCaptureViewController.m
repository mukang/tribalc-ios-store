//
//  TCIDCardCaptureViewController.m
//  store
//
//  Created by 穆康 on 2017/4/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCIDCardCaptureViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TCIDCardCaptureViewController ()

@property (weak, nonatomic) UIView *containerView;

@property (nonatomic) CGRect captureRect;
/** 执行输入设备和输出设备之间的数据传递 */
@property (strong, nonatomic) AVCaptureSession *session;
/** 输入设备 */
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
/** 照片输出流 */
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
/** 预览图层 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation TCIDCardCaptureViewController {
    __weak TCIDCardCaptureViewController *weakSelf;
}

- (instancetype)initWithCapturePosition:(TCIDCardCapturePosition)capturePosition {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _capturePosition = capturePosition;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hideOriginalNavBar = YES;
    
    [self setupSubviews];
    [self setupAVCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)setupSubviews {
    // 容器
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.frame = self.view.bounds;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    // 拍照捕捉框和提示文字
    UIImageView *captureImageView = [[UIImageView alloc] init];
    UILabel *noticeLabel = [[UILabel alloc] init];
    if (self.capturePosition == TCIDCardCapturePositionFront) {
        captureImageView.image = [UIImage imageNamed:@"certification_ID_position_front"];
        noticeLabel.text = @"请将身份证正面置于此区域内并对齐边缘";
    } else {
        captureImageView.image = [UIImage imageNamed:@"certification_ID_position_back"];
        noticeLabel.text = @"请将身份证背面置于此区域内并对齐边缘";
    }
    captureImageView.size = CGSizeMake(TCRealValue(TCRealValue(266)), TCRealValue(422));
    captureImageView.centerX = TCScreenWidth * 0.5;
    captureImageView.y = TCRealValue(122.5);
    [containerView addSubview:captureImageView];
    
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [noticeLabel sizeToFit];
    noticeLabel.center = CGPointMake(CGRectGetMaxX(captureImageView.frame) + TCRealValue(14), captureImageView.centerY);
    [containerView addSubview:noticeLabel];
    noticeLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    // 捕捉区域
    self.captureRect = CGRectInset(captureImageView.frame, 2, 2);
    
    // 镂空
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:containerView.bounds];
    [overlayPath setUsesEvenOddFillRule:YES];
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:self.captureRect];
    [overlayPath appendPath:transparentPath];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = containerView.bounds;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.path = overlayPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.65].CGColor;
    [containerView.layer addSublayer:fillLayer];
    
    // 拍照按钮
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setImage:[UIImage imageNamed:@"certification_ID_take_photo_button"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(handleTakePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    photoButton.size = CGSizeMake(TCRealValue(47), TCRealValue(47));
    photoButton.center = CGPointMake(TCScreenWidth * 0.5, TCScreenHeight - TCRealValue(65.5));
    [containerView addSubview:photoButton];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"certification_ID_back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.size = CGSizeMake(TCRealValue(47), TCRealValue(47));
    backButton.origin = CGPointMake(17.5, 15);
    [containerView addSubview:backButton];
    
    // 闪光灯按钮
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setImage:[UIImage imageNamed:@"certification_ID_flash_auto"] forState:UIControlStateNormal];
    [flashButton addTarget:self action:@selector(handleClickFlashButton:) forControlEvents:UIControlEventTouchUpInside];
    flashButton.size = backButton.size;
    flashButton.x = TCScreenWidth - flashButton.width - 17.5;
    flashButton.y = 15;
    [containerView addSubview:flashButton];
}

- (void)setupAVCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:nil];
    if ([device hasFlash]) [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    NSError *error;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        TCLog(@"%s --> %@", __func__, error);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

#pragma mark - Actions

- (void)handleTakePhotoButton:(UIButton *)sender {
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:jpegData];
        if (weakSelf.captureCompletion) {
            weakSelf.captureCompletion(image);
        }
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)handleTapBackButton:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 闪光灯
 */
- (void)handleClickFlashButton:(UIButton *)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 修改前必须锁定
    [device lockForConfiguration:nil];
    // 必须判定是否有闪光灯，如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            [sender setImage:[UIImage imageNamed:@"certification_ID_flash_on"] forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            [sender setImage:[UIImage imageNamed:@"certification_ID_flash_auto"] forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            [sender setImage:[UIImage imageNamed:@"certification_ID_flash_off"] forState:UIControlStateNormal];
        }
    }
    [device unlockForConfiguration];
}

#pragma mark - Status Bar

- (BOOL)prefersStatusBarHidden {
    return YES;
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
