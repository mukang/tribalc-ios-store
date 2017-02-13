//
//  TCGoodsDeliveryView.m
//  store
//
//  Created by 穆康 on 2017/2/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsDeliveryView.h"
#import "UIImage+Category.h"

static CGFloat const duration = 0.25;

@interface TCGoodsDeliveryView ()

@property (weak, nonatomic) UIView *containerView;

@end

@implementation TCGoodsDeliveryView {
    __weak TCGoodsDeliveryView *weakSelf;
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
        weakSelf.containerView.y = (TCScreenHeight - weakSelf.containerView.height) * 0.5;
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
    
    CGFloat containerViewH = 300;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"物流公司";
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:nameLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"物流编号";
    numLabel.textColor = TCRGBColor(42, 42, 42);
    numLabel.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:numLabel];
    
    UITextField *numTextField = [[UITextField alloc] init];
    numTextField.textColor = TCRGBColor(42, 42, 42);
    numTextField.font = [UIFont systemFontOfSize:14];
    numTextField.keyboardType = UIKeyboardTypeASCIICapable;
    numTextField.returnKeyType = UIReturnKeyDone;
    numTextField.layer.borderWidth = 1;
    numTextField.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
    numTextField.layer.masksToBounds = YES;
    [self.containerView addSubview:numTextField];
    
    UIButton *cancelButton = [self buttonWithTitle:@"取消"
                                       normalImage:[UIImage imageWithColor:TCRGBColor(252, 108, 38)]
                                  highlightedImage:[UIImage imageWithColor:TCRGBColor(236, 85, 11)]
                                            action:@selector(dismiss)];
    [self.containerView addSubview:cancelButton];
    
    UIButton *deliveryButton = [self buttonWithTitle:@"确认发货"
                                         normalImage:[UIImage imageWithColor:TCRGBColor(81, 199, 209)]
                                    highlightedImage:[UIImage imageWithColor:TCRGBColor(10, 164, 177)]
                                              action:@selector(handleClickDeliveryButton:)];
    [self.containerView addSubview:deliveryButton];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.containerView.mas_top).with.offset(50);
    }];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(20);
    }];
    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLabel.mas_right);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-20);
        make.top.equalTo(numLabel.mas_top);
        make.bottom.equalTo(numLabel.mas_bottom);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(TCRealValue(60));
        make.bottom.equalTo(weakSelf.containerView.mas_bottom).with.offset(-40);
        make.height.mas_equalTo(40);
        make.right.equalTo(deliveryButton.mas_left).with.offset(-40);
    }];
    [deliveryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(TCRealValue(-60));
        make.bottom.equalTo(weakSelf.containerView.mas_bottom).with.offset(-40);
        make.height.mas_equalTo(40);
        make.width.equalTo(cancelButton.mas_width);
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                }];
    [button setAttributedTitle:attTitle forState:UIControlStateNormal];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Actions

- (void)handleTapBgView:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

- (void)handleClickDeliveryButton:(UIButton *)sender {
    [self dismiss];
}

@end
