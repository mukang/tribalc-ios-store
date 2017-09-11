//
//  TCBioEditPhoneFailView.m
//  individual
//
//  Created by 王帅锋 on 2017/9/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditPhoneFailView.h"
#import <TCCommonLibs/TCCommonButton.h>

@implementation TCBioEditPhoneFailView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0.6);
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 5.0;
    centerView.clipsToBounds = YES;
    [self addSubview:centerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"editPhoneFailViewImage"];
    [centerView addSubview:imageView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"editPhoneFailViewDelete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:deleteBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"修改手机号";
    [centerView addSubview:titleLabel];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"当前修改将清除全部个人银行卡是否继续？";
    desLabel.textColor = TCBlackColor;
    desLabel.numberOfLines = 0;
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = [UIFont systemFontOfSize:11];
    [centerView addSubview:desLabel];
    
    TCCommonButton *cancleBtn = [TCCommonButton buttonWithTitle:@"取  消" color:TCCommonButtonColorPurple target:self action:@selector(delete)];
    [centerView addSubview:cancleBtn];
    
    TCCommonButton *confirmBtn = [TCCommonButton buttonWithTitle:@"继  续" color:TCCommonButtonColorPurple target:self action:@selector(confirm)];
    [centerView addSubview:confirmBtn];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(105);
        make.width.equalTo(@226);
        make.height.equalTo(@195);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView).offset(12);
        make.centerX.equalTo(centerView);
        make.width.height.equalTo(@70);
    }];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(centerView);
        make.width.height.equalTo(@20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(centerView);
        make.top.equalTo(imageView.mas_bottom).offset(7);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(centerView);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(10);
        make.top.equalTo(desLabel.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(confirmBtn);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancleBtn).offset(10);
        make.right.equalTo(centerView).offset(-10);
        make.top.height.width.equalTo(cancleBtn);
    }];
}

- (void)confirm {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickConfirmButton)]) {
        [self.delegate didClickConfirmButton];
        [self delete];
    }
}

- (void)delete {
    [self removeFromSuperview];
}

@end
