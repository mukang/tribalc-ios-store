//
//  TCUnCommonView.m
//  store
//
//  Created by 王帅锋 on 17/2/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUnCommonView.h"
#import "TCCommonButton.h"
#import <Masonry.h>

@interface TCUnCommonView ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) TCCommonButton *btn;

@end

@implementation TCUnCommonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUnCommonType:(TCUnCommonType)unCommonType {
    
    _unCommonType = unCommonType;
    
    switch (unCommonType) {
        case TCUnCommonTypeNoContent:
            self.imageView.image = [UIImage imageNamed:@"noContent"];
            self.desLabel.text = @"还没有商品哦，请点击右下角按钮添加商品吧！";
            self.btn.hidden = YES;
            break;
        case TCUnCommonTypeUnCommon:
            self.imageView.image = [UIImage imageNamed:@"unAuth"];
            self.desLabel.text = @"店铺认证过后才可以创建商品哦，请先进行店铺认证！";
            self.btn.hidden = NO;
        
            [self.btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"去认证"
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                      NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                      }] forState:UIControlStateNormal];
            break;
        case TCUnCommonTypeUnLogin:
            self.imageView.image = [UIImage imageNamed:@"unLogin"];
            self.desLabel.text = @"您还有登录哦！请您点击下方按钮进行登录";
            self.btn.hidden = NO;
            [self.btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"登  录"
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                      NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                      }] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setUpSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.desLabel];
    [self addSubview:self.btn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(TCRealValue(145)));
        make.width.height.equalTo(@(TCRealValue(117)));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(TCRealValue(35));
        make.right.equalTo(self).offset(-TCRealValue(35));
        make.top.equalTo(self.imageView.mas_bottom).offset(TCRealValue(25));
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(TCRealValue(30));
//        make.right.equalTo(self).offset(-TCRealValue(30));
        make.top.equalTo(self.desLabel.mas_bottom).offset(TCRealValue(30));
        make.height.equalTo(@(TCRealValue(40)));
        make.centerX.equalTo(self);
        make.width.equalTo(@(TCRealValue(150)));
    }];
}

- (void)toAuth {
    if (self.delegate) {
        if (self.unCommonType == TCUnCommonTypeUnLogin) {
            if ([self.delegate respondsToSelector:@selector(toLogin)]) {
                [self.delegate toLogin];
            }
        }else if (self.unCommonType == TCUnCommonTypeUnCommon) {
            if ([self.delegate respondsToSelector:@selector(toAuth)]) {
                [self.delegate toAuth];
            }
        }
    }
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = TCGrayColor;
        _desLabel.numberOfLines = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _desLabel;
}

- (UIButton *)btn {
    if (_btn == nil) {
        _btn = [TCCommonButton buttonWithTitle:@"去认证" color:TCCommonButtonColorOrange target:self action:@selector(toAuth)];
    }
    return _btn;
}

@end
