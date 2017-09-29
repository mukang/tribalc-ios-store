//
//  TCGoodsRefundView.m
//  store
//
//  Created by 穆康 on 2017/9/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsRefundView.h"

#define duration 0.25

@interface TCGoodsRefundView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIPickerView *pickerView;
@property (copy, nonatomic) NSArray *dataList;

@end

@implementation TCGoodsRefundView {
    __weak TCGoodsRefundView *weakSelf;
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

- (void)dismissCompletion:(void (^)())completion {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.containerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
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
    
    CGFloat containerViewH = 256;
    CGFloat buttonW = 60;
    CGFloat buttonH = 40;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"取消"
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                NSForegroundColorAttributeName: TCBlackColor
                                                                                }];
    [cancelButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(20, 0, buttonW, buttonH);
    [containerView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    attTitle = [[NSAttributedString alloc] initWithString:@"退款"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCBlackColor
                                                            }];
    [confirmButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(handleClickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = CGRectMake(containerView.width - 20 - buttonW, 0, buttonW, buttonH);
    [containerView addSubview:confirmButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = TCBackgroundColor;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.frame = CGRectMake(0, 40, containerView.width, containerView.height - 40);
    [containerView addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataList.count;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = TCBlackColor;
        label.font = [UIFont systemFontOfSize:16];
        label.adjustsFontSizeToFitWidth = YES;
        label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    label.text = self.dataList[row];
    return label;
}

#pragma mark - Actions

- (void)handleClickCancelButton:(UIButton *)sender {
    [self dismiss];
}

- (void)handleClickConfirmButton:(UIButton *)sender {
    [self dismissCompletion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(goodsRefundView:didClickRefundButtonWithReason:)]) {
            NSInteger row = [weakSelf.pickerView selectedRowInComponent:0];
            [self.delegate goodsRefundView:weakSelf didClickRefundButtonWithReason:weakSelf.dataList[row]];
        }
    }];
}

- (void)handleTapBgView:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

#pragma mark - Override Methods

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[
                      @"商品暂时无货",
                      @"商品已下架",
                      @"买家申请退款",
                      @"其他"
                      ];
    }
    return _dataList;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
