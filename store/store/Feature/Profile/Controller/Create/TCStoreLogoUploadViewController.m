//
//  TCStoreLogoUploadViewController.m
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreLogoUploadViewController.h"
#import "TCNavigationController.h"

#import "TCCommonButton.h"

#import "TCPhotoModeView.h"
#import "TCPhotoPicker.h"

#import "TCBuluoApi.h"

#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

@interface TCStoreLogoUploadViewController () <TCPhotoModeViewDelegate, TCPhotoPickerDelegate>

@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@end

@implementation TCStoreLogoUploadViewController {
    __weak TCStoreLogoUploadViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = TCBackgroundColor;
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupLogo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.title = @"LOGO图";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开店手册"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickManualItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"请上传清晰的LOGO图";
    promptLabel.textColor = TCBlackColor;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:promptLabel];
    
    TCCommonButton *uploadButton = [TCCommonButton buttonWithTitle:@"LOGO上传"
                                                             color:TCCommonButtonColorOrange
                                                            target:self
                                                            action:@selector(handleClickUploadButton:)];
    [self.view addSubview:uploadButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(10);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(5);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-5);
        make.height.mas_equalTo(TCRealValue(209));
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.left.right.equalTo(weakSelf.view);
    }];
    [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(69);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupLogo {
    if (self.logo) {
        UIImage *placeholder = [UIImage placeholderImageWithSize:CGSizeMake(TCScreenWidth, TCRealValue(209))];
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.logo];
        [self.imageView sd_setImageWithURL:URL placeholderImage:placeholder options:SDWebImageRetryFailed];
    } else {
        self.imageView.image = [UIImage imageNamed:@"store_logo_example"];
    }
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
    [[TCBuluoApi api] uploadImage:coverImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.logo = [TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS];
            [weakSelf updateLogo];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"上传失败，%@", reason]];
        }
    }];
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickUploadButton:(UIButton *)sender {
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

- (void)updateLogo {
    UIImage *placeholder = self.imageView.image;
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.logo];
    [self.imageView sd_setImageWithURL:URL placeholderImage:placeholder options:SDWebImageRetryFailed];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    if (self.uploadLogoCompletion) {
        self.uploadLogoCompletion(self.logo);
    }
    [super handleClickBackButton:sender];
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
