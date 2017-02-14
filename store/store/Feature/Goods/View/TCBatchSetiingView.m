//
//  TCBatchSetiingView.m
//  store
//
//  Created by 王帅锋 on 17/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBatchSetiingView.h"
#import <Masonry.h>
#import "MBProgressHUD+Category.h"

@interface TCBatchSetiingView ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *priceTextField;

@property (strong, nonatomic) UITextField *reperotyTextField;

@end

@implementation TCBatchSetiingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *centerView = [[UIView alloc] init];
    centerView.layer.cornerRadius = 3.0;
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.clipsToBounds = YES;
    [self addSubview:centerView];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"批量设定价格/库存";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.backgroundColor = TCRGBColor(222, 99, 53);
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:topLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = @"输入价格";
    priceLabel.font = [UIFont systemFontOfSize:14];
    [centerView addSubview:priceLabel];
    
    UITextField *priceTextField = [[UITextField alloc] init];
    priceTextField.placeholder = @"  统一输入价格";
    priceTextField.delegate = self;
    priceTextField.layer.cornerRadius = 3.0;
    priceTextField.clipsToBounds = YES;
    priceTextField.font = [UIFont systemFontOfSize:14];
    priceTextField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    priceTextField.layer.borderWidth = 0.5;
    [centerView addSubview:priceTextField];
    self.priceTextField = priceTextField;
    
    UILabel *reperotyLabel = [[UILabel alloc] init];
    reperotyLabel.text = @"输入库存";
    reperotyLabel.textAlignment = NSTextAlignmentRight;
    reperotyLabel.font = [UIFont systemFontOfSize:14];
    [centerView addSubview:reperotyLabel];
    
    UITextField *reperotyTextField = [[UITextField alloc] init];
    reperotyTextField.placeholder = @"  统一输入库存";
    reperotyTextField.layer.cornerRadius = 3.0;
    reperotyTextField.clipsToBounds = YES;
    reperotyTextField.delegate = self;
    reperotyTextField.font = [UIFont systemFontOfSize:14];
    reperotyTextField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    reperotyTextField.layer.borderWidth = 0.5;
    [centerView addSubview:reperotyTextField];
    self.reperotyTextField = reperotyTextField;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"您可以只设定价格或只设定库存";
    desLabel.font = [UIFont systemFontOfSize:12];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.textColor = TCRGBColor(154, 154, 154);
    [centerView addSubview:desLabel];
    
    UIView *heLineView = [[UIView alloc] init];
    heLineView.backgroundColor = TCRGBColor(154, 154, 154);
    [centerView addSubview:heLineView];
    
    UIButton *cancelBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:TCRGBColor(222, 99, 53) forState:UIControlStateNormal];
    [centerView addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(154, 154, 154);
    [cancelBtn addSubview:lineView];
    
    UIButton *certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
    [certainBtn setTitleColor:TCRGBColor(222, 99, 53) forState:UIControlStateNormal];
    [centerView addSubview:certainBtn];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.centerY.equalTo(self);
        make.height.equalTo(@240);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(centerView);
        make.height.equalTo(@43);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(topLabel.mas_bottom).offset(25);
        make.width.equalTo(@95);
        make.height.equalTo(@32);
    }];
    
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(10);
        make.top.height.equalTo(priceLabel);
        make.right.equalTo(centerView).offset(-30);
    }];
    
    [reperotyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(priceLabel);
        make.top.equalTo(priceLabel.mas_bottom).offset(10);
    }];
    
    [_reperotyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(_priceTextField);
        make.top.equalTo(reperotyLabel);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(centerView);
        make.top.equalTo(_reperotyTextField.mas_bottom).offset(20);
        make.height.equalTo(@15);
    }];
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2 : 3;
    
    [heLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(centerView);
        make.top.equalTo(desLabel.mas_bottom).offset(15);
        make.height.equalTo(@(1/scale));
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heLineView.mas_bottom);
        make.left.bottom.equalTo(centerView);
        make.width.equalTo(centerView).multipliedBy(0.5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(cancelBtn);
        make.width.equalTo(@(1/scale));
    }];
    
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(cancelBtn);
        make.left.equalTo(cancelBtn.mas_right);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn)]) {
//            [self.delegate textFieldShouldReturn];
//        }
//    }
    return YES;
}

- (void)certain {
    
    if (_priceTextField.text.length == 0 && _reperotyTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入价格或库存"];
        return;
    }
    
    NSMutableDictionary *mutabelDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *priceStr = _priceTextField.text;
    if ([priceStr isKindOfClass:[NSString class]]) {
        priceStr = [priceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [mutabelDic setObject:priceStr forKey:@"price"];
    }
    NSString *reperotyStr = _reperotyTextField.text;
    if ([reperotyStr isKindOfClass:[NSString class]]) {
        reperotyStr = [reperotyStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [mutabelDic setObject:reperotyStr forKey:@"reperoty"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KTCUPDATESTANDARDPRICEORREPEROTY" object:nil userInfo:mutabelDic];
    [self cancelClick];
}

- (void)cancelClick {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
