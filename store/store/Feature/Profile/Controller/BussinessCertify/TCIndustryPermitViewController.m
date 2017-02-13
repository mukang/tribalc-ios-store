//
//  TCIndustryPermitViewController.m
//  store
//
//  Created by 王帅锋 on 17/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCIndustryPermitViewController.h"
#import <Masonry.h>
#import "TCCommonButton.h"
#import "TCPhotoPicker.h"
#import "TCPhotoModeView.h"
#import "TCBuluoApi.h"
#import "TCAuthenticationInfo.h"
#import "TCImageURLSynthesizer.h"

@interface TCIndustryPermitViewController ()<TCPhotoModeViewDelegate,TCPhotoPickerDelegate>

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *nextBtn;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (strong, nonatomic) TCAuthenticationInfo *authInfo;

@end

@implementation TCIndustryPermitViewController

- (instancetype)initWithAuthInfo:(TCAuthenticationInfo *)info {
    if (self = [super init]) {
        self.authInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *point1 = [[UIView alloc] init];
    point1.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point1];
    point1.layer.cornerRadius = TCRealValue(6)/2;
    point1.clipsToBounds = YES;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"必须公司行业许可证，且内容清晰可辩，必填";
    label1.textColor = TCRGBColor(154, 154, 154);
    label1.font = [UIFont systemFontOfSize:13];
    label1.numberOfLines = 0;
    [self.view addSubview:label1];
    
    UIView *point2 = [[UIView alloc] init];
    point2.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point2];
    point2.layer.cornerRadius = TCRealValue(6)/2;
    point2.clipsToBounds = YES;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"请您确认拍照权限已开";
    label2.textColor = TCRGBColor(154, 154, 154);
    label2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label2];
    
    UIView *point3 = [[UIView alloc] init];
    point3.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point3];
    point3.layer.cornerRadius = TCRealValue(6)/2;
    point3.clipsToBounds = YES;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"本页为必填项";
    label3.textColor = TCRGBColor(154, 154, 154);
    label3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label3];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(toChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"行业许可证扫描上传";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TCRGBColor(154, 154, 154);
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    imageView.layer.cornerRadius = 5.0;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
    imageView.layer.borderWidth = 0.5;
    self.imageView = imageView;
    
    TCCommonButton *nextBtn = [TCCommonButton bottomButtonWithTitle:@"提   交" color:TCCommonButtonColorOrange target:self action:@selector(commit)];
    [self.view addSubview:nextBtn];
    nextBtn.layer.cornerRadius = 5.0;
    nextBtn.clipsToBounds = YES;
    nextBtn.enabled = NO;
    self.nextBtn = nextBtn;
    
    [point1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TCRealValue(23));
        make.left.equalTo(self.view).offset(TCRealValue(23));
        make.width.height.equalTo(@(TCRealValue(6)));
    }];
    
    CGFloat w = TCScreenWidth - TCRealValue(54);
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TCRealValue(18));
        make.left.equalTo(point1.mas_right).offset(5);
        make.width.equalTo(@(w));
    }];
    
    [point2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.left.equalTo(point1);
        make.width.height.equalTo(point1);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.width.equalTo(@(w));
        make.height.equalTo(@16);
    }];
    
    [point3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point2);
        make.top.equalTo(label2.mas_bottom).offset(10);
        make.width.height.equalTo(point1);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point3.mas_right).offset(5);
        make.top.equalTo(label2.mas_bottom).offset(5);
        make.width.equalTo(@(w));
        make.height.equalTo(label2);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(TCRealValue(40)));
        make.top.equalTo(label3.mas_bottom).offset(TCRealValue(85));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(btn.mas_bottom).offset(20);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(TCRealValue(25));
        make.left.equalTo(self.view).offset(TCRealValue(35));
        make.right.equalTo(self.view).offset(-TCRealValue(35));
        make.height.equalTo(@(TCRealValue(180)));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(TCRealValue(30));
        make.right.equalTo(self.view).offset(-(TCRealValue(30)));
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(43));
        make.height.equalTo(@(TCRealValue(40)));
    }];

}

- (void)toChoosePhoto {
    
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

#pragma mark - TCPhotoModeViewDelegate

- (void)didClickCameraButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    self.photoPicker = photoPicker;
}

- (void)didClickAlbumButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.photoPicker = photoPicker;
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
    
    UIImage *coverImage;
    if (info[UIImagePickerControllerEditedImage]) {
        coverImage = info[UIImagePickerControllerEditedImage];
    } else {
        coverImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] uploadImage:coverImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        @StrongObj(self)
        if (success) {
            [MBProgressHUD hideHUD:YES];
            self.nextBtn.enabled = YES;
            self.imageView.image = coverImage;
            self.authInfo.tradeLicense = [TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

- (void)commit {
    [MBProgressHUD showHUD:YES];
    
    [[TCBuluoApi api] putStoreAuthenticationInfo:self.authInfo result:^(TCStoreInfo *storeInfo, NSError *error) {
        if (storeInfo) {
            [[TCBuluoApi api] currentUserSession].storeInfo = storeInfo;
            [MBProgressHUD showHUDWithMessage:@"认证信息提交成功，认证正在处理中"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];

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
