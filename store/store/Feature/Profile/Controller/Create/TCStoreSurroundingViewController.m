//
//  TCStoreSurroundingViewController.m
//  store
//
//  Created by 穆康 on 2017/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreSurroundingViewController.h"
#import "TCNavigationController.h"

#import <TCCommonLibs/TCCommonButton.h>
#import "TCStoreSurroundingViewCell.h"

#import <TCCommonLibs/TCPhotoModeView.h>
#import "TCPhotoPicker.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCStoreSurroundingViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
TCPhotoModeViewDelegate,
TCPhotoPickerDelegate,
TCStoreSurroundingViewCellDelegate>

@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UILabel *countLabel;

@property (weak, nonatomic) UILabel *promptLabel;
@property (weak, nonatomic) TCCommonButton *uploadButton;

@property (strong, nonatomic) NSMutableArray *pictures;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger totalCount;

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@end

@implementation TCStoreSurroundingViewController {
    __weak TCStoreSurroundingViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = TCBackgroundColor;
    self.pictures = [NSMutableArray arrayWithArray:self.storeDetailInfo.pictures];
    self.currentIndex = 100;
    self.totalCount = 9;
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupConstraints];
    [self updateSubviews];
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

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.title = @"环境图";
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
    imageView.image = [UIImage imageNamed:@"store_surrounding_example"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf(TCRealValue(113)), floorf(TCRealValue(88)));
    layout.minimumLineSpacing = floorf(TCRealValue(8));
    layout.minimumInteritemSpacing = floorf(TCRealValue(8));
    layout.sectionInset = UIEdgeInsetsMake(floorf(TCRealValue(20)), floorf(TCRealValue(10)), 0, floorf(TCRealValue(10)));
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCStoreSurroundingViewCell class] forCellWithReuseIdentifier:@"TCStoreSurroundingViewCell"];
    [self.containerView addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = TCGrayColor;
    countLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:countLabel];
    self.countLabel = countLabel;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    if ([self.storeDetailInfo.storeType isEqualToString:@"GOODS"]) {
        promptLabel.text = @"上传漂亮的商铺环境图，可以大大提高用户购买率\n图片要求无水印，上传的图片尺寸在2000×1500以上更好（非必须上传）。";
    } else {
        promptLabel.text = @"上传漂亮的顾客用餐环境图或者您店铺的外景图，可以大大提高用户购买率\n图片要求无水印，上传的图片尺寸在2000×1500以上更好（必须上传）。";
    }
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = TCBlackColor;
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.numberOfLines = 0;
    [self.view addSubview:promptLabel];
    self.promptLabel = promptLabel;
    
    TCCommonButton *uploadButton = [TCCommonButton buttonWithTitle:@"上传照片"
                                                             color:TCCommonButtonColorOrange
                                                            target:self
                                                            action:@selector(handleClickUploadButton:)];
    [self.view addSubview:uploadButton];
    self.uploadButton = uploadButton;
}

- (void)setupConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(10);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(5);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-5);
        make.height.mas_equalTo(TCRealValue(209));
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(10);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(TCRealValue(148));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.containerView);
        make.bottom.equalTo(weakSelf.containerView.mas_bottom).with.offset(TCRealValue(-40));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(TCRealValue(10));
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(TCRealValue(-10));
        make.bottom.equalTo(weakSelf.containerView.mas_bottom);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageView.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
    }];
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageView.mas_bottom).with.offset(69);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
}

- (void)updateSubviews {
    if (self.pictures.count == 0) {
        self.imageView.hidden = NO;
        self.containerView.hidden = YES;
        [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.imageView.mas_bottom).with.offset(10);
            make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
            make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        }];
        [self.uploadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.imageView.mas_bottom).with.offset(69);
            make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
            make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
            make.height.mas_equalTo(40);
        }];
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"已上传%zd张，还可以上传%zd张", self.pictures.count, self.totalCount - self.pictures.count];
        self.imageView.hidden = YES;
        self.containerView.hidden = NO;
        if (self.pictures.count <= 3) {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TCRealValue(148));
            }];
        } else if (self.pictures.count <= 6) {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TCRealValue(246));
            }];
        } else {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TCRealValue(344));
            }];
        }
        [self.promptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.containerView.mas_bottom).with.offset(10);
            make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
            make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        }];
        [self.uploadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.containerView.mas_bottom).with.offset(69);
            make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
            make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
            make.height.mas_equalTo(40);
        }];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreSurroundingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCStoreSurroundingViewCell" forIndexPath:indexPath];
    NSString *picture = self.pictures[indexPath.item];
    cell.picture = picture;
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
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
    [[TCBuluoApi api] uploadImage:coverImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            NSString *picture = [TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS];
            if (weakSelf.pictures.count > weakSelf.currentIndex) {
                [weakSelf.pictures replaceObjectAtIndex:weakSelf.currentIndex withObject:picture];
            } else {
                [weakSelf.pictures addObject:picture];
            }
            weakSelf.currentIndex = 100;
            [weakSelf updateSubviews];
            [weakSelf.collectionView reloadData];
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

#pragma mark - TCStoreSurroundingViewCellDelegate

- (void)didClickDeleteButtonInStoreSurroundingViewCell:(TCStoreSurroundingViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.pictures removeObjectAtIndex:indexPath.item];
    [self updateSubviews];
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (void)handleClickManualItem:(UIBarButtonItem *)sender {
    
}

- (void)handleClickUploadButton:(UIButton *)sender {
    if (self.pictures.count == self.totalCount) {
        [MBProgressHUD showHUDWithMessage:@"已上传9张图片，不能继续上传"];
        return;
    }
    self.currentIndex = 100;
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    self.storeDetailInfo.pictures = [self.pictures copy];
    if (self.editSurroundingCompletion) {
        self.editSurroundingCompletion();
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
