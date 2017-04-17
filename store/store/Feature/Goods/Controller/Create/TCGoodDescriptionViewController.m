//
//  TCGoodDescriptionViewController.m
//  store
//
//  Created by 王帅锋 on 17/4/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodDescriptionViewController.h"
#import "TCGoodDescriptionImageCell.h"
#import <TCPhotoModeView.h>
#import "TCPhotoPicker.h"
#import "TCBuluoApi.h"
#import "TCImageURLSynthesizer.h"

@interface TCGoodDescriptionViewController ()<UITableViewDelegate, UITableViewDataSource,TCPhotoModeViewDelegate,TCPhotoPickerDelegate,TCGoodDescriptionImageCellDelegate>

@property (strong, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *addPhotoBtn;

@property (strong, nonatomic) UIButton *doneBtn;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

//@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TCGoodDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
}

- (void)setUpViews {
    
    self.view.backgroundColor = TCBackgroundColor;
    
    [self.view addSubview:self.desLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addPhotoBtn];
    [self.view addSubview:self.doneBtn];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    [self.addPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.equalTo(@50);
    }];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPhotoBtn.mas_right);
        make.width.height.bottom.equalTo(self.addPhotoBtn);
    }];
    
    if ([self.urlArr isKindOfClass:[NSArray class]]) {
        self.desLabel.hidden = YES;
        self.tableView.hidden = NO;
    }else {
        self.desLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = self.urlArr[indexPath.section];
    if ([str isKindOfClass:[NSString class]]) {
        NSArray *arr = [str componentsSeparatedByString:@"="];
        if (arr.count > 1) {
            NSString *lastStr = arr.lastObject;
            if ([lastStr isKindOfClass:[NSString class]]) {
                return [lastStr floatValue]*TCScreenWidth;
            }
        }
    }
    
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.urlArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodDescriptionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodDescriptionImageCell"];
    cell.delegate = self;
    cell.urlStr = self.urlArr[indexPath.section];
    return cell;
}

- (void)done {
    if (self.doneBlock) {
        self.doneBlock(self.urlArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPhoto {
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

#pragma mark - TCGoodDescriptionImageCellDelegate

-(void)didClickDeleteBtn:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.urlArr];
    [mutableArr removeObjectAtIndex:indexPath.section];
    self.urlArr = mutableArr;
    [self.tableView reloadData];
    if (!self.urlArr.count) {
        self.tableView.hidden = YES;
        self.desLabel.hidden = NO;
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
    
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] uploadImage:coverImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        @StrongObj(self)
        if (success) {
            [MBProgressHUD hideHUD:YES];
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.urlArr];
            NSString *str = [TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS];
            [mutableArr addObject: [NSString stringWithFormat:@"%@?scale=%.2f",str,coverImage.size.height/coverImage.size.width]];
            self.urlArr = mutableArr;
            self.desLabel.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            
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



- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGFLOAT_MIN)];
        [_tableView registerClass:[TCGoodDescriptionImageCell class] forCellReuseIdentifier:@"TCGoodDescriptionImageCell"];
//        _tableView.sectionHeaderHeight = 10;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"请添加图片让你的宝贝看起来更诱人";
        _desLabel.textColor = TCBlackColor;
        _desLabel.font = [UIFont systemFontOfSize:16];
    }
    return _desLabel;
}

- (UIButton *)addPhotoBtn {
    if (_addPhotoBtn == nil) {
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotoBtn setBackgroundColor:[UIColor whiteColor]];
        [_addPhotoBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addPhotoBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [_addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}

- (UIButton *)doneBtn {
    if (_doneBtn == nil) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[UIColor orangeColor]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
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
