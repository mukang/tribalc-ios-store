//
//  TCGoodSelectTitleView.m
//  individual
//
//  Created by WYH on 16/12/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodSelectTitleView.h"

@implementation TCGoodSelectTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        _selectImageView = [self getSelectImageViewWithFrame:CGRectMake(TCRealValue(20), TCRealValue(-9), TCRealValue(115), TCRealValue(115))];
        [self addSubview:_selectImageView];
        
        _selectPriceLab = [self getSelectPriceLabWithFrame:CGRectMake(_selectImageView.x + _selectImageView.width + TCRealValue(12), TCRealValue(20), self.width - _selectImageView.x - _selectImageView.width - TCRealValue(12), TCRealValue(20))];
        [self addSubview:_selectPriceLab];
        
        _selectRepertoryLab = [self getSelectRepertoryLabWithFrame:CGRectMake(_selectPriceLab.x, _selectPriceLab.y + _selectPriceLab.height + TCRealValue(12), _selectPriceLab.width, TCRealValue(12))];
        [self addSubview:_selectRepertoryLab];
        
        UILabel *selectTagLab = [self getSelectStandardLabWithFrame:CGRectMake(_selectRepertoryLab.x, _selectRepertoryLab.y + _selectRepertoryLab.height + TCRealValue(13), TCRealValue(45), TCRealValue(14)) AndTextColor:[UIColor blackColor]];
        selectTagLab.font = [UIFont systemFontOfSize:TCRealValue(14)];
        selectTagLab.text = @"已选择";
        [self addSubview:selectTagLab];
        
        _selectPrimaryLab  = [self getSelectStandardLabWithFrame:CGRectMake(selectTagLab.x + selectTagLab.width + TCRealValue(5), selectTagLab.y - TCRealValue(1), 0, TCRealValue(14)) AndTextColor:TCRGBColor(81, 199, 209)];
        [self addSubview:_selectPrimaryLab];
        
        _selectSecondaryLab = [self getSelectStandardLabWithFrame:_selectPrimaryLab.frame AndTextColor:_selectPrimaryLab.textColor];
        [self addSubview:_selectSecondaryLab];
        
    }
    
    return self;
}

- (void)setupRepertory:(NSInteger)repertory {
    _selectRepertoryLab.text = [NSString stringWithFormat:@"(剩余:%li件)", (long)repertory];
}

- (NSInteger)getRepertory {
    NSArray *repertoryArr = [_selectRepertoryLab.text componentsSeparatedByString:@":"];
    repertoryArr = [repertoryArr[1] componentsSeparatedByString:@"件"];
    NSString *repertoryStr = repertoryArr[0];
    return repertoryStr.integerValue;
}

- (void)setupPrimary:(NSString *)primary {
    _selectPrimaryLab.text = primary;
    [_selectPrimaryLab sizeToFit];
    _selectSecondaryLab.x = _selectPrimaryLab.x + _selectPrimaryLab.width + TCRealValue(10);
    if ([primary isEqualToString:@""]) {
        _selectSecondaryLab.x = _selectPrimaryLab.x;
    }
}

- (void)setupSecondary:(NSString *)secondary {
    _selectSecondaryLab.text = secondary;
    [_selectSecondaryLab sizeToFit];
    if (![_selectPrimaryLab.text isEqualToString:@""]) {
        _selectSecondaryLab.x = _selectPrimaryLab.x + _selectPrimaryLab.width + TCRealValue(10);
    }
}

- (UIImageView *)getSelectImageViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = TCRealValue(5);
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = TCRealValue(1.5);
    imageView.layer.borderColor = TCBackgroundColor.CGColor;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

- (UILabel *)getSelectPriceLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(20)];
    label.textColor = TCRGBColor(81, 199, 209);
    
    return label;
}

- (UILabel *)getSelectRepertoryLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(12)];
    label.textColor = TCGrayColor;
    
    return label;
}

- (UILabel *)getSelectStandardLabWithFrame:(CGRect)frame AndTextColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:TCRealValue(14)];
    label.text = @"";
    
    return label;
}

@end
