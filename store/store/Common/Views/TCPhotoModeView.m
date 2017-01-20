//
//  TCPhotoModeView.m
//  individual
//
//  Created by 穆康 on 2016/12/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPhotoModeView.h"
#import "UIImage+Category.h"

static CGFloat const duration = 0.25;

@interface TCPhotoModeView ()

@property (weak, nonatomic) UIView *containerView;

@end

@implementation TCPhotoModeView {
    __weak TCPhotoModeView *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithController:(UIViewController *)controller {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        weakSelf = self;
        sourceController = controller;
        [self initPrivate];
    }
    return self;
}

- (void)show {
    if (!sourceController) return;
    
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.containerView.y = TCScreenHeight - weakSelf.containerView.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.containerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Private Methods

- (void)initPrivate {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [self addSubview:backgroundView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBgView:)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    CGFloat containerViewH = 182;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, containerViewH)];
    containerView.backgroundColor = TCRGBColor(242, 242, 242);
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *cameraButton = [self setupButtonWithTitle:@"拍照" action:@selector(handleClickCameraButton:)];
    UIButton *albumButton = [self setupButtonWithTitle:@"从手机相册选择" action:@selector(handleClickAlbumButton:)];
    UIButton *cancelButton = [self setupButtonWithTitle:@"取消" action:@selector(handleClickCancelButton:)];
    [containerView addSubview:cameraButton];
    [containerView addSubview:albumButton];
    [containerView addSubview:cancelButton];
    
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top).with.offset(17);
        make.left.equalTo(containerView.mas_left).with.offset(35);
        make.right.equalTo(containerView.mas_right).with.offset(-35);
        make.height.mas_equalTo(31);
    }];
    
    [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_bottom).with.offset(12);
        make.left.equalTo(containerView.mas_left).with.offset(35);
        make.right.equalTo(containerView.mas_right).with.offset(-35);
        make.height.mas_equalTo(31);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(albumButton.mas_bottom).with.offset(30);
        make.left.equalTo(containerView.mas_left).with.offset(35);
        make.right.equalTo(containerView.mas_right).with.offset(-35);
        make.height.mas_equalTo(31);
    }];
}

- (UIButton *)setupButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:title
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                              NSForegroundColorAttributeName: TCRGBColor(42, 42, 42)
                                                                              }];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:title
                                                                           attributes:@{
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                        NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                                        }];
    [button setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = 2.5;
    button.layer.masksToBounds = YES;
    
    return button;
}

#pragma mark - Actions

- (void)handleClickCameraButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCameraButtonInPhotoModeView:)]) {
        [self.delegate didClickCameraButtonInPhotoModeView:self];
    }
}

- (void)handleClickAlbumButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAlbumButtonInPhotoModeView:)]) {
        [self.delegate didClickAlbumButtonInPhotoModeView:self];
    }
}

- (void)handleClickCancelButton:(UIButton *)sender {
    [self dismiss];
}

- (void)handleTapBgView:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

@end
