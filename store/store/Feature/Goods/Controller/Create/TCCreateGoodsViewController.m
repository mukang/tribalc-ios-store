//
//  TCCreateGoodsViewController.m
//  store
//
//  Created by 王帅锋 on 17/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateGoodsViewController.h"
#import <TCCommonLibs/TCCommonButton.h>
#import "TCGoodsDetailTitleCell.h"
#import "TCCommonInputViewCell.h"
#import <TCCommonLibs/TCCommonSubtitleViewCell.h>
#import <TCCommonLibs/TCCommonIndicatorViewCell.h>
#import <YYText.h>
#import "TCCreateGoodsStandardController.h"
#import "TCGoodsIssueViewController.h"
#import <TCCommonLibs/TCPhotoModeView.h>
#import "TCPhotoPicker.h"
#import "TCBuluoApi.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/TCImagePlayerView.h>
#import "TCSetMainGoodCell.h"

@interface TCCreateGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,TCCommonInputViewCellDelegate,YYTextViewDelegate,TCPhotoModeViewDelegate,TCPhotoPickerDelegate,TCGoodsDetailTitleCellDelegate,TCImagePlayerViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCCommonButton *nextBtn;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@property (strong, nonatomic) UIButton *chosePhotoBtn;

@property (strong, nonatomic) TCImagePlayerView *imagePlayerView;

@property (strong, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) UIButton *setMainPhotoBtn;

@property (copy, nonatomic) NSString *currentMainGoodsStandardKey;

@end

@implementation TCCreateGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布商品";
 
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (void)setUpViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0.01;
    _tableView.sectionHeaderHeight = 9.0;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TCRealValue(250))];
    
    TCImagePlayerView *imageView = [[TCImagePlayerView alloc] initWithFrame:headView.bounds];
    imageView.delegate = self;
    [headView addSubview:imageView];
    [imageView prohibitPlay];
    self.imagePlayerView = imageView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:btn];
    [btn addTarget:self action:@selector(chosePhoto) forControlEvents:UIControlEventTouchUpInside];
    self.chosePhotoBtn = btn;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setTitle:@"设为主图" forState:UIControlStateNormal];
    [setBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [setBtn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [headView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setMainPhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.setMainPhotoBtn = setBtn;
    if (self.goods.pictures) {
        [imageView setPictures:self.goods.pictures isLocal:NO];
        if ([self.goods.mainPicture isKindOfClass:[NSString class]]) {
            NSInteger index = [self.imagePlayerView getCurrentPictureIndex];
            if (index < self.goods.pictures.count) {
                NSString *str = self.goods.pictures[index];
                if ([str isKindOfClass:[NSString class]]) {
                    if ([str isEqualToString:self.goods.mainPicture]) {
                        setBtn.selected = YES;
                        [setBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    
    _nextBtn = [TCCommonButton bottomButtonWithTitle:@"下一步" color:TCCommonButtonColorOrange target:self action:@selector(next)];
    [self.view addSubview:_nextBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-20);
        make.bottom.equalTo(headView).offset(-20);
        make.width.height.equalTo(@(TCRealValue(42)));
    }];
    
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-20);
        make.top.equalTo(headView).offset(20);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TCRealValue(50));
    }];
    
    if (self.goods.pictures) {
        if (self.goods.pictures.count) {
            self.deleteBtn.hidden = NO;
            self.setMainPhotoBtn.hidden = NO;
            [btn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headView).offset(20);
                make.bottom.equalTo(headView).offset(-20);
                make.width.equalTo(@(TCRealValue(42)));
                make.height.equalTo(@(TCRealValue(42)));
            }];
        }else {
            self.deleteBtn.hidden = YES;
            self.setMainPhotoBtn.hidden = YES;
            [btn setImage:[UIImage imageNamed:@"chosePhoto"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(headView);
                make.width.equalTo(@(TCRealValue(62)));
                make.height.equalTo(@(TCRealValue(54)));
            }];
        }
        
    }else {
        self.deleteBtn.hidden = YES;
        self.setMainPhotoBtn.hidden = YES;
        [btn setImage:[UIImage imageNamed:@"chosePhoto"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(headView);
            make.width.equalTo(@(TCRealValue(62)));
            make.height.equalTo(@(TCRealValue(54)));
        }];
    }
    
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom);
    }];
    
    _tableView.tableHeaderView = headView;
    
}

- (void)setMainPhoto:(UIButton *)btn {
    if (!self.goods.pictures) {
        return;
    }
    
    if (!self.goods.pictures.count) {
        return;
    }
    
    if (btn.selected) {
        return;
    }
    
    btn.selected = YES;
    [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    
    NSInteger index = [self.imagePlayerView getCurrentPictureIndex];
    if (index < self.goods.pictures.count) {
        NSString *str = self.goods.pictures[index];
        if ([str isKindOfClass:[NSString class]]) {
            self.goods.mainPicture = str;
        }
    }
}


- (void)deletePhoto {
    if (!self.goods.pictures) {
        return;
    }
    
    if (!self.goods.pictures.count) {
        return;
    }
    
    NSInteger index = [self.imagePlayerView getCurrentPictureIndex];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.goods.pictures];
    if (index < mutableArr.count) {
        [mutableArr removeObjectAtIndex:index];
        self.goods.pictures = mutableArr;
        [self.imagePlayerView setPictures:mutableArr isLocal:NO];
        
        if (mutableArr.count) {

        }else {
            self.deleteBtn.hidden = YES;
            self.setMainPhotoBtn.hidden = YES;
            [self.chosePhotoBtn setImage:[UIImage imageNamed:@"chosePhoto"] forState:UIControlStateNormal];
            [self.chosePhotoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(self.tableView.tableHeaderView);
                make.width.equalTo(@(TCRealValue(62)));
                make.height.equalTo(@(TCRealValue(54)));
            }];
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
            [self.view layoutIfNeeded];
        }
    }
    
}

- (void)chosePhoto {
    [self.view endEditing:YES];
    TCPhotoModeView *photoModeView = [[TCPhotoModeView alloc] initWithController:self];
    photoModeView.delegate = self;
    [photoModeView show];
}

#pragma mark - TCImagePlayerViewDelegate

- (void)didScrollToIndex:(NSInteger)index {
    if (index < self.goods.pictures.count) {
        NSString *imageStr = self.goods.pictures[index];
        if ([self.goods.mainPicture isKindOfClass:[NSString class]]) {
            if ([self.goods.mainPicture isEqualToString:imageStr]) {
                self.setMainPhotoBtn.selected = YES;
                [self.setMainPhotoBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            }else {
                self.setMainPhotoBtn.selected = NO;
                [self.setMainPhotoBtn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
            }
        }else {
            self.setMainPhotoBtn.selected = NO;
            [self.setMainPhotoBtn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
        }
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
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.goods.pictures];
            [mutableArr addObject:[TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS]];
            self.goods.pictures = mutableArr;
            [self.imagePlayerView setPictures:mutableArr isLocal:NO];
            self.deleteBtn.hidden = NO;
            self.setMainPhotoBtn.hidden = NO;
            if (self.chosePhotoBtn.centerX == self.view.centerX) {
                [self.chosePhotoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.tableView.tableHeaderView).offset(20);
                    make.bottom.equalTo(self.tableView.tableHeaderView).offset(-20);
                    make.width.equalTo(@(TCRealValue(42)));
                    make.height.equalTo(@(TCRealValue(42)));
                }];
                [self.chosePhotoBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
                [self.view setNeedsUpdateConstraints];
                [self.view updateConstraintsIfNeeded];
                [self.view layoutIfNeeded];
            }
            
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


#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else {
            return 45;
        }
    }else {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.goods.standardId && self.currentGoodsStandardMate) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        
        if (self.goods.standardId && self.currentGoodsStandardMate) {
            if (self.currentGoodsStandardMate.descriptions.primary && self.currentGoodsStandardMate.descriptions.secondary) {
                return 7;
            }else if (self.currentGoodsStandardMate.descriptions.primary) {
                return 6;
            }
        }
        
        if (self.currentGoodsStandardMate) {
            return 3;
        }
        return 6;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCGoodsDetailTitleCell *cell = [[TCGoodsDetailTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCGoodsDetailTitleCell"];
            cell.delegate = self;
            if ([self.goods.title isKindOfClass:[NSString class]]) {
                [cell setTitle:self.goods.title];
            }
            return cell;
        }else {
            TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
            cell.delegate = self;
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"列表标题";
                cell.placeholder = @"例：现货包邮MAC魅可VIVA GLAM限量版";
                if ([self.goods.name isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.name;
                }
            }else if (indexPath.row == 2) {
                cell.titleLabel.text = @"简短说明";
                cell.placeholder = @"请用一句话概括商品";
                if ([self.goods.note isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.note;
                }
            }
            return cell;
        }
    }else if (indexPath.section == 1) {
        
        if (self.goods.standardId && self.currentGoodsStandardMate) {
            if (indexPath.row == 0) {
                TCCommonSubtitleViewCell *cell = [[TCCommonSubtitleViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonSubtitleViewCell"];
                cell.titleLabel.text = @"类别";
                NSString *categoryStr = self.goods.category;
                if ([categoryStr isKindOfClass:[NSString class]]) {
                    if ([categoryStr isEqualToString:@"FOOD"]) {
                        categoryStr = @"美食";
                    }else if ([categoryStr isEqualToString:@"GIFT"]) {
                        categoryStr = @"礼品";
                    }else if ([categoryStr isEqualToString:@"OFFICE"]) {
                        categoryStr = @"办公用品";
                    }else if ([categoryStr isEqualToString:@"LIVING"]) {
                    categoryStr = @"生活用品";
                    }else if ([categoryStr isEqualToString:@"HOUSE"]) {
                    categoryStr = @"家具用品";
                    }else if ([categoryStr isEqualToString:@"MAKEUP"]) {
                        categoryStr = @"个护化妆";
                    }else if ([categoryStr isEqualToString:@"PENETRATION"]) {
                        categoryStr = @"妇婴用品";
                    }else if ([categoryStr isEqualToString:@"PENETRATION"]) {
                        categoryStr = @"会员卡";
                    }
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"商品>%@",categoryStr];
                }
                
                return cell;
            }else if (indexPath.row == 1) {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"品牌";
                cell.placeholder = @"请输入商品品牌";
                cell.delegate = self;
                if ([self.goods.brand isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.brand;
                }
                return cell;
            }else if (indexPath.row == 2) {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonIndicatorViewCell"];
                cell.titleLabel.text = self.currentGoodsStandardMate.descriptions.primary.label;
                cell.placeholder = @"请输入商品一级规格";
                cell.delegate = self;
                if (self.goods.standardKeys.count) {
                    cell.textField.text = self.goods.standardKeys.firstObject;
                }
                return cell;
            }else if (indexPath.row == 3) {
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonIndicatorViewCell"];
                    cell.titleLabel.text = self.currentGoodsStandardMate.descriptions.secondary.label;
                    cell.placeholder = @"请输入商品二级规格";
                    cell.delegate = self;
                    if (self.goods.standardKeys.count == 2) {
                        cell.textField.text = self.goods.standardKeys[1];
                    }
                    return cell;
                }
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"销售价格";
                cell.placeholder = @"请输入商品销售价格";
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                cell.delegate = self;
                
                if (self.goods.priceAndRepertory.salePrice) {
                    cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.salePrice];
                }
                
                return cell;
            }else if (indexPath.row == 4) {
                
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                    cell.titleLabel.text = @"销售价格";
                    cell.placeholder = @"请输入商品销售价格";
                    cell.delegate = self;
                    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    if (self.goods.priceAndRepertory.salePrice) {
                        cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.salePrice];
                    }
                    return cell;
                }
                
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"原始价格";
                cell.placeholder = @"请输入商品原始价格";
                cell.delegate = self;
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (self.goods.priceAndRepertory.originPrice) {
                    cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.originPrice];
                }
                return cell;
            }else if (indexPath.row == 5) {
                
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                    cell.titleLabel.text = @"原始价格";
                    cell.placeholder = @"请输入商品原始价格";
                    cell.delegate = self;
                    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    if (self.goods.priceAndRepertory.originPrice) {
                        cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.originPrice];
                    }
                    return cell;
                }
                
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"库存量";
                cell.placeholder = @"请输入商品库存量";
                cell.delegate = self;
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (self.goods.priceAndRepertory.repertory) {
                    cell.textField.text = [NSString stringWithFormat:@"%ld",self.goods.priceAndRepertory.repertory];
                }
                return cell;
            }else {
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                    cell.titleLabel.text = @"库存量";
                    cell.placeholder = @"请输入商品库存量";
                    cell.delegate = self;
                    cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                    if (self.goods.priceAndRepertory.repertory) {
                        cell.textField.text = [NSString stringWithFormat:@"%ld",self.goods.priceAndRepertory.repertory];
                    }
                    return cell;
                }else {
                    return nil;
                }
            }
        }else {
            if (indexPath.row == 0) {
                TCCommonSubtitleViewCell *cell = [[TCCommonSubtitleViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonSubtitleViewCell"];
                cell.titleLabel.text = @"类别";
//                cell.subtitleLabel.text = [NSString stringWithFormat:@"商品>%@",self.goods.category];
                NSString *categoryStr = self.goods.category;
                if ([categoryStr isKindOfClass:[NSString class]]) {
                    if ([categoryStr isEqualToString:@"FOOD"]) {
                        categoryStr = @"美食";
                    }else if ([categoryStr isEqualToString:@"GIFT"]) {
                        categoryStr = @"礼品";
                    }else if ([categoryStr isEqualToString:@"OFFICE"]) {
                        categoryStr = @"办公用品";
                    }else if ([categoryStr isEqualToString:@"LIVING"]) {
                        categoryStr = @"生活用品";
                    }else if ([categoryStr isEqualToString:@"HOUSE"]) {
                        categoryStr = @"家具用品";
                    }else if ([categoryStr isEqualToString:@"MAKEUP"]) {
                        categoryStr = @"个护化妆";
                    }else if ([categoryStr isEqualToString:@"PENETRATION"]) {
                        categoryStr = @"妇婴用品";
                    }else if ([categoryStr isEqualToString:@"PENETRATION"]) {
                        categoryStr = @"会员卡";
                    }
                    cell.subtitleLabel.text = [NSString stringWithFormat:@"商品>%@",categoryStr];
                }
                return cell;
            }else if (indexPath.row == 1) {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"品牌";
                cell.placeholder = @"请输入商品品牌";
                cell.delegate = self;
                if ([self.goods.brand isKindOfClass:[NSString class]]) {
                    cell.textField.text = self.goods.brand;
                }
                return cell;
            }else if (indexPath.row == 2) {
                TCCommonIndicatorViewCell *cell = [[TCCommonIndicatorViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonIndicatorViewCell"];
                cell.titleLabel.text = @"规格";
                cell.subtitleLabel.text = @"请输入商品规格";
                if (self.currentGoodsStandardMate) {
                    cell.subtitleLabel.text = self.currentGoodsStandardMate.title;
                }
                return cell;
            }else if (indexPath.row == 3) {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"销售价格";
                cell.placeholder = @"请输入商品销售价格";
                cell.delegate = self;
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (self.goods.priceAndRepertory.salePrice) {
                    cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.salePrice];
                }
                
                return cell;
            }else if (indexPath.row == 4) {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"原始价格";
                cell.placeholder = @"请输入商品原始价格";
                cell.delegate = self;
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (self.goods.priceAndRepertory.originPrice) {
                    cell.textField.text = [NSString stringWithFormat:@"%.2f",self.goods.priceAndRepertory.originPrice];
                }
                return cell;
            }else {
                TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
                cell.titleLabel.text = @"库存量";
                cell.placeholder = @"请输入商品库存量";
                cell.delegate = self;
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (self.goods.priceAndRepertory.repertory) {
                    cell.textField.text = [NSString stringWithFormat:@"%ld",self.goods.priceAndRepertory.repertory];
                }
                return cell;
            }
        }
        
    }else if (indexPath.section == 2) {
        TCCommonInputViewCell *cell = [[TCCommonInputViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCCommonInputViewCell"];
        cell.titleLabel.text = @"原产国";
        cell.placeholder = @"请输入商品原产国";
        cell.delegate = self;
        if ([self.goods.originCountry isKindOfClass:[NSString class]]) {
            cell.textField.text = self.goods.originCountry;
        }
        return cell;
    }else {
        TCSetMainGoodCell *cell = [[TCSetMainGoodCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TCSetMainGoodCell"];
        if (self.goods.primary) {
            cell.select = YES;
        }
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.goods.standardId) {
        if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                TCGoodsStandardMate *standardMate = self.currentGoodsStandardMate;
                TCCreateGoodsStandardController *createVc = [[TCCreateGoodsStandardController alloc] initWithGoodsStandardMate:standardMate];
//                if (self.currentGoodsStandardMate) {
//                    createVc.goodsStandardMate = self.currentGoodsStandardMate;
//                }
                @WeakObj(self)
                createVc.myBlock = ^(TCGoodsStandardMate *goodsStandardMate,NSString *key){
                    @StrongObj(self)
                    self.currentGoodsStandardMate = goodsStandardMate;
                    self.currentMainGoodsStandardKey = key;
                    if (self.goods.priceAndRepertory) {
                        self.goods.priceAndRepertory = nil;
                    }
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:createVc animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
    }else {
        if (indexPath.section == 3) {
            if (!self.goods.primary) {
                self.goods.primary = YES;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

#pragma mark TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.currentIndexPath = indexPath;
    
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    self.currentIndexPath = nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            self.goods.name = textField.text;
        }else if (indexPath.row == 2) {
            self.goods.note = textField.text;
        }
    }else if (indexPath.section == 1) {
        
        if (self.goods.standardId && self.currentGoodsStandardMate) {
            if (indexPath.row == 1) {
                self.goods.brand = textField.text;
            }else if (indexPath.row == 2) {

            }else if (indexPath.row == 3) {
                
                if (self.currentGoodsStandardMate.descriptions.secondary) {

                    
                }else {
                    [self setGoodsSalePrice:textField.text];
                }
                
            }else if (indexPath.row == 4) {
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    [self setGoodsSalePrice:textField.text];
                }else {
                    [self setGoodsOriginPrice:textField.text];
                }
                
            }else if (indexPath.row == 5) {
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    [self setGoodsOriginPrice:textField.text];
                }else {
                    [self setGoodsReperoty:textField.text];
                }
            }else {
                if (self.currentGoodsStandardMate.descriptions.secondary) {
                    [self setGoodsReperoty:textField.text];
                }
            }
        }else {
            if (indexPath.row == 1) {
                self.goods.brand = textField.text;
            }else if (indexPath.row == 3) {
                [self setGoodsSalePrice:textField.text];
            }else if (indexPath.row == 4) {
                [self setGoodsOriginPrice:textField.text];
            }else if (indexPath.row == 5) {
                [self setGoodsReperoty:textField.text];
            }
        }
        
    }else {
        self.goods.originCountry = textField.text;
    }
}

- (void)setGoodsSalePrice:(NSString *)text {
    if (self.goods.priceAndRepertory == nil) {
        self.goods.priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
    }
    self.goods.priceAndRepertory.salePrice = [text doubleValue];
}

- (void)setGoodsOriginPrice:(NSString *)text {
    if (self.goods.priceAndRepertory == nil) {
        self.goods.priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
    }
    self.goods.priceAndRepertory.originPrice = [text doubleValue];
}

- (void)setGoodsReperoty:(NSString *)text {
    if (self.goods.priceAndRepertory == nil) {
        self.goods.priceAndRepertory = [[TCGoodsPriceAndRepertory alloc] init];
    }
    self.goods.priceAndRepertory.repertory = [text integerValue];
}

#pragma mark - TCGoodsDetailTitleCellDelegate

- (void)textViewShouldBeginEditting:(YYTextView *)textView {
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)textViewDidEndEditting:(YYTextView *)textView {
    self.currentIndexPath = nil;
    self.goods.title = textView.text;
}


#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height - 49, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height - 49, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)next {
    
    if (!self.goods.name) {
        [MBProgressHUD showHUDWithMessage:@"请输入商品标题"];
        return;
    }
    
    if ([self.goods.name isKindOfClass:[NSString class]]) {
        if (!self.goods.name.length) {
            [MBProgressHUD showHUDWithMessage:@"请输入商品标题"];
            return;
        }
    }
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    if (self.goods.standardId && self.currentGoodsStandardMate) {
        TCCommonInputViewCell *cell = (TCCommonInputViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        if (cell.textField.text.length > 0) {
            [mutableArr addObject:cell.textField.text];
        }else {
            [MBProgressHUD showHUDWithMessage:@"请输入一级规格"];
            return;
        }
        
        
        if (self.currentGoodsStandardMate.descriptions.secondary) {
            TCCommonInputViewCell *sCell = (TCCommonInputViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
            if (sCell.textField.text.length > 0) {
                [mutableArr addObject:sCell.textField.text];
            }else {
                [MBProgressHUD showHUDWithMessage:@"请输入二级规格"];
                return;
            }
        }
        self.goods.standardKeys = mutableArr;
        
        if (!self.goods.priceAndRepertory) {
            [MBProgressHUD showHUDWithMessage:@"请输入价格库存信息"];
            return;
        }
    }
    
    if (!self.goods.standardId && !self.currentGoodsStandardMate) {
        if (!self.goods.priceAndRepertory) {
            [MBProgressHUD showHUDWithMessage:@"请输入价格库存信息"];
            return;
        }else {
            if (!self.goods.priceAndRepertory.salePrice) {
                [MBProgressHUD showHUDWithMessage:@"请输入价格"];
                return;
            }
            if (!self.goods.priceAndRepertory.repertory) {
                [MBProgressHUD showHUDWithMessage:@"请输入库存"];
                return;
            }
        }
    }
    
    if (self.goods.standardId && self.currentGoodsStandardMate) {
        if (self.goods.priceAndRepertory) {
            if (!self.goods.priceAndRepertory.salePrice) {
                [MBProgressHUD showHUDWithMessage:@"请输入价格"];
                return;
            }
            if (!self.goods.priceAndRepertory.repertory) {
                [MBProgressHUD showHUDWithMessage:@"请输入库存"];
                return;
            }
        }
    }
    
    //设置商品主图
    if (![self.goods.mainPicture isKindOfClass:[NSString class]]) {
        if ([self.goods.pictures isKindOfClass:[NSArray class]]) {
            if (self.goods.pictures.count) {
                NSString *mainP = self.goods.pictures[0];
                if ([mainP isKindOfClass:[NSString class]]) {
                    self.goods.mainPicture = mainP;
                }
            }
        }
    }
    
    
    TCGoodsIssueViewController *issueVC = [[TCGoodsIssueViewController alloc] init];
    TCGoodsMeta *goodMeta = self.goods;
    issueVC.goods = goodMeta;
    if (self.currentGoodsStandardMate) {
        TCGoodsStandardMate *standardMate = self.currentGoodsStandardMate;
        issueVC.goodsStandardMate = standardMate;
    }
    
    if (self.currentMainGoodsStandardKey) {
        NSString *key = self.currentMainGoodsStandardKey;
        issueVC.mainGoodsStandardKey = key;
    }
    
    [self.navigationController pushViewController:issueVC animated:YES];
}

- (void)dealloc {
    NSLog(@"------ TCCreateGoodsViewController ------");
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
