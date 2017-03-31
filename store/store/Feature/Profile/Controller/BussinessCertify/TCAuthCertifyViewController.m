//
//  TCAuthCertifyViewController.m
//  store
//
//  Created by 王帅锋 on 17/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAuthCertifyViewController.h"
#import <Masonry.h>
#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/TCPhotoModeView.h>
#import "TCPhotoPicker.h"
#import "TCBuluoApi.h"
#import "TCIndustryPermitViewController.h"
#import "TCAuthenticationInfo.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>

@interface TCAuthCertifyViewController ()<TCPhotoPickerDelegate,TCPhotoModeViewDelegate>

@property (strong, nonatomic) UIImageView *frontImageView;

@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (strong, nonatomic) TCCommonButton *nextBtn;

@property (strong, nonatomic) TCAuthenticationInfo *authInfo;

@property (copy, nonatomic) NSMutableArray *imageArr;

@end

@implementation TCAuthCertifyViewController

//- (NSMutableArray *)mutableArr {
//    if (_mutableArr == nil) {
//        _mutableArr = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _mutableArr;
//}

- (instancetype)initWithAuthInfo:(TCAuthenticationInfo *)info {
    if (self = [super init]) {
        self.authInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"身份认证";
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    UIView *point1 = [[UIView alloc] init];
    point1.backgroundColor = TCRGBColor(235, 24, 19);
    [scrollView addSubview:point1];
    point1.layer.cornerRadius = TCRealValue(6)/2;
    point1.clipsToBounds = YES;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"请确保上传身份证与当前注册手机号持有人身份一致";
    label1.textColor = TCGrayColor;
    label1.font = [UIFont systemFontOfSize:13];
    label1.numberOfLines = 0;
    [scrollView addSubview:label1];
    
    UIView *point2 = [[UIView alloc] init];
    point2.backgroundColor = TCRGBColor(235, 24, 19);
    [scrollView addSubview:point2];
    point2.layer.cornerRadius = TCRealValue(6)/2;
    point2.clipsToBounds = YES;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"请确保身份证照片拍摄清晰，且尽量匹配相框尺寸";
    label2.textColor = TCGrayColor;
    label2.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:label2];
    
    UIView *point3 = [[UIView alloc] init];
    point3.backgroundColor = TCRGBColor(235, 24, 19);
    [scrollView addSubview:point3];
    point3.layer.cornerRadius = TCRealValue(6)/2;
    point3.clipsToBounds = YES;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"本页为必填项";
    label3.textColor = TCGrayColor;
    label3.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:label3];
    
    UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [frontBtn setBackgroundColor:[UIColor redColor]];
    [frontBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    frontBtn.tag = 11111;
    [frontBtn addTarget:self action:@selector(toChoosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:frontBtn];
    
    UILabel *frontLabel = [[UILabel alloc] init];
    frontLabel.text = @"身份证正面扫描上传";
    frontLabel.textAlignment = NSTextAlignmentCenter;
    frontLabel.textColor = TCGrayColor;
    frontLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:frontLabel];
    
    UIImageView *frontImageView = [[UIImageView alloc] init];
    [scrollView addSubview:frontImageView];
    frontImageView.layer.cornerRadius = 5.0;
    frontImageView.clipsToBounds = YES;
    frontImageView.contentMode = UIViewContentModeScaleAspectFill;
    frontImageView.layer.borderColor = TCGrayColor.CGColor;
    frontImageView.layer.borderWidth = 0.5;
    self.frontImageView = frontImageView;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setBackgroundColor:[UIColor redColor]];
    [backBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    backBtn.tag = 22222;
    [backBtn addTarget:self action:@selector(toChoosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];
    
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.text = @"身份证反面扫描上传";
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.textColor = TCGrayColor;
    backLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:backLabel];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    [scrollView addSubview:backImageView];
    backImageView.layer.cornerRadius = 5.0;
    backImageView.clipsToBounds = YES;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.layer.borderColor = TCGrayColor.CGColor;
    backImageView.layer.borderWidth = 0.5;
    self.backImageView = backImageView;
    
    TCCommonButton *nextBtn = [TCCommonButton bottomButtonWithTitle:@"下一步" color:TCCommonButtonColorOrange target:self action:@selector(next)];
    [scrollView addSubview:nextBtn];
    nextBtn.layer.cornerRadius = 5.0;
    nextBtn.clipsToBounds = YES;
    self.nextBtn = nextBtn;
    nextBtn.enabled = NO;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [point1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(TCRealValue(23));
        make.left.equalTo(scrollView).offset(TCRealValue(23));
        make.width.height.equalTo(@(TCRealValue(6)));
    }];
    
    CGFloat w = TCScreenWidth - TCRealValue(54);
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(TCRealValue(18));
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
    
    [frontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.width.equalTo(@(TCRealValue(47)));
        make.height.equalTo(@(TCRealValue(37)));
        make.top.equalTo(label3.mas_bottom).offset(TCRealValue(85));
    }];
    
    [frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(frontBtn.mas_bottom).offset(20);
    }];
    
    [frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(TCRealValue(25));
        make.left.equalTo(self.view).offset(TCRealValue(38));
        make.right.equalTo(self.view).offset(-TCRealValue(38));
        make.height.equalTo(@(TCRealValue(181)));
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.width.equalTo(@(TCRealValue(47)));
        make.height.equalTo(@(TCRealValue(37)));
        make.top.equalTo(frontImageView.mas_bottom).offset(TCRealValue(75));
    }];
    
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(backBtn.mas_bottom).offset(20);
    }];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frontImageView.mas_bottom).offset(TCRealValue(20));
        make.left.right.height.equalTo(frontImageView);
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(TCRealValue(30));
        make.right.equalTo(self.view).offset(-(TCRealValue(30)));
        make.top.equalTo(backImageView.mas_bottom).offset(TCRealValue(43));
        make.height.equalTo(@(TCRealValue(40)));
        make.bottom.equalTo(scrollView).offset(-(TCRealValue(40)));
    }];

}

- (void)toChoosePhoto:(UIButton *)btn {
    self.selectedBtn = btn;
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}


#pragma mark - TCPhotoModeViewDelegate

- (void)didClickCameraButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.allowsEditing = NO;
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    self.photoPicker = photoPicker;
}

- (void)didClickAlbumButtonInPhotoModeView:(TCPhotoModeView *)view {
    [view dismiss];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.allowsEditing = NO;
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
            
            NSString *str = [TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS];
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.imageArr];
            if (self.selectedBtn) {
                if (self.selectedBtn.tag == 11111) {
                    self.frontImageView.image = coverImage;
                    if (mutableArr.count == 0) {
                        [mutableArr addObject:str];
                    }else if (mutableArr.count == 1) {
                        [mutableArr insertObject:str atIndex:0];
                    }else {
                        [mutableArr replaceObjectAtIndex:0 withObject:str];
                    }
                }else {
                    self.backImageView.image = coverImage;
                    if (mutableArr.count == 0) {
                        [mutableArr addObject:str];
                    }else if (mutableArr.count == 1) {
                        [mutableArr addObject:str];
                    }else {
                        [mutableArr replaceObjectAtIndex:1 withObject:str];
                    }
                }
            }
            
            if (self.frontImageView.image && self.backImageView.image) {
                self.nextBtn.enabled = YES;
            }
            
            
//            NSLog(@"%@", [TCImageURLSynthesizer synthesizeImageURLWithPath:str].absoluteString);
//            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.imageArr];
//            [mutableArr addObject:str];
            self.imageArr = mutableArr;
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
    self.selectedBtn = nil;
}

- (void)next {
    
    self.authInfo.idCardPicture = self.imageArr;
    
    TCIndustryPermitViewController *industryVC = [[TCIndustryPermitViewController alloc] initWithAuthInfo:self.authInfo];
    [self.navigationController pushViewController:industryVC animated:YES];
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
