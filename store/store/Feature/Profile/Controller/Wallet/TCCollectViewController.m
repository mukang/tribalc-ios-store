//
//  TCCollectViewController.m
//  store
//
//  Created by 王帅锋 on 17/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCollectViewController.h"
#import "TCBuluoApi.h"
#import "TCWalletBillViewController.h"
#import "TCImageURLSynthesizer.h"
#import <UIImageView+WebCache.h>
#import <Photos/Photos.h>

#define TCQRWIDTH 180

@interface TCCollectViewController ()

@property (strong, nonatomic) UIImageView *qrImageView;

@property (strong, nonatomic) UIButton *btn;

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (strong, nonatomic) UIView *centerView;

@property (strong, nonatomic) UILabel *titleBtn;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *saveBtn;

@property (strong, nonatomic) UIImageView *titleIcon;

@end

@implementation TCCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款";
    [self prepareNav];
    [self setUpViews];
}

- (void)setUpViews {
    self.view.backgroundColor = TCRGBColor(246, 171, 114);
    
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.btn];
    [self.centerView addSubview:self.titleBtn];
    [self.centerView addSubview:self.titleLabel];
    [self.centerView addSubview:self.qrImageView];
    [self.centerView addSubview:self.saveBtn];
    
    [self.centerView addSubview:self.titleIcon];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(TCRealValue(117));
        make.width.equalTo(@(TCRealValue(330)));
        make.height.equalTo(@(TCRealValue(345)));
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(TCRealValue(100)));
        make.height.equalTo(@30);
    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.centerView);
        make.height.equalTo(@(TCRealValue(40)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.centerView);
        make.top.equalTo(self.titleBtn.mas_bottom).offset(TCRealValue(20));
        make.height.equalTo(@(TCRealValue(15)));
    }];
    
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView);
        make.width.height.equalTo(@(TCRealValue(TCQRWIDTH)));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(TCRealValue(30));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView);
        make.top.equalTo(self.qrImageView.mas_bottom).offset(TCRealValue(15));
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    [self.titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(10);
        make.width.equalTo(@17);
        make.height.equalTo(@15);
        make.top.equalTo(self.centerView).offset((TCRealValue(40)-15)/2);
    }];
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
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"收款"];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
}


- (void)toBill {
    TCWalletBillViewController *walletBillVC = [[TCWalletBillViewController alloc] init];
    walletBillVC.tradingType = @"RECEIPT";
    walletBillVC.face2face = @"true";
    [self.navigationController pushViewController:walletBillVC animated:YES];
}


- (void)save {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(520))];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((TCScreenWidth-205)/2, TCRealValue(50), 205, 500)];
    [view addSubview:titleView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [UIImage imageNamed:@"app_icon_120"];
    imageView.layer.cornerRadius = 10.0;
    imageView.clipsToBounds = YES;
    [titleView addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 150, 50)];
    titleLabel.text = @"嗨托邦支付";
    titleLabel.font = [UIFont systemFontOfSize:25];
    titleLabel.textColor = TCBlackColor;
    [titleView addSubview:titleLabel];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, TCRealValue(136), TCScreenWidth, TCRealValue(384))];
    mainView.backgroundColor = TCRGBColor(246, 171, 114);
    [view addSubview:mainView];
    
    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectMake((TCScreenWidth-TCRealValue(240))/2, TCRealValue(56), TCRealValue(240), TCRealValue(240))];
    imageBgView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:imageBgView];
    
    UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(15), TCRealValue(15), TCRealValue(210), TCRealValue(210))];
    qrImageView.image = self.qrImageView.image;
    [imageBgView addSubview:qrImageView];
    
    if ([TCBuluoApi api].currentUserSession.storeInfo.logo) {
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((TCRealValue(210)-TCRealValue(57))/2, (TCRealValue(210)-TCRealValue(57))/2, TCRealValue(57), TCRealValue(57))];
        logoImageView.layer.cornerRadius = TCRealValue(57)/2;
        logoImageView.clipsToBounds = YES;
        logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        logoImageView.layer.borderWidth = 3.0;
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:[TCBuluoApi api].currentUserSession.storeInfo.logo];
        [logoImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        [qrImageView addSubview:logoImageView];
    }
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageBgView.frame)+20, TCScreenWidth, 20)];
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = [NSString stringWithFormat:@"向%@付款",[TCBuluoApi api].currentUserSession.storeInfo.name];
    [mainView addSubview:desLabel];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:viewImage];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDWithMessage:@"保存成功"];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDWithMessage:@"保存失败"];
            });
        }
    }];
}

- (UIButton *)saveBtn {
    if (_saveBtn == nil) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存至相册" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _saveBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"扫描二维码向我付款";
    }
    return _titleLabel;
}

- (UILabel *)titleBtn {
    if (_titleBtn == nil) {
        _titleBtn = [[UILabel alloc] init];
        _titleBtn.textAlignment = NSTextAlignmentLeft;
        _titleBtn.text = @"        我要收款";
        _titleBtn.font = [UIFont systemFontOfSize:14];
        _titleBtn.backgroundColor = TCRGBColor(242, 238, 238);
    }
    return _titleBtn;
}

- (UIImageView *)titleIcon {
    if (_titleIcon == nil) {
        _titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleIcon"]];
    }
    return _titleIcon;
}

- (UIView *)centerView {
    if (_centerView == nil) {
        _centerView = [[UIView alloc] init];
        _centerView.layer.cornerRadius = 5.0;
        _centerView.clipsToBounds = YES;
        _centerView.backgroundColor = [UIColor whiteColor];
    }
    return _centerView;
}

- (UIButton *)btn {
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"收款账单" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn addTarget:self action:@selector(toBill) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIImageView *)qrImageView {
    if (_qrImageView == nil) {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.backgroundColor = [UIColor redColor];
        _qrImageView.image = [self generateQRCodeImageWithCodeString:[NSString stringWithFormat:@"pay://stores/%@",[TCBuluoApi api].currentUserSession.assigned] size:CGSizeMake(TCQRWIDTH, TCQRWIDTH)];
    }
    return _qrImageView;
}

#pragma mark - Generate QRCode

- (UIImage *)generateQRCodeImageWithCodeString:(NSString *)codeString size:(CGSize)size {
    if (codeString.length) {
        NSData *data = [codeString dataUsingEncoding:NSUTF8StringEncoding];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        CIImage *outputImage = filter.outputImage;
        
        return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size.width];
    } else {
        return nil;
    }
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
