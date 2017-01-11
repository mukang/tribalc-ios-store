//
//  TCRecommendSelectView.m
//  individual
//
//  Created by WYH on 16/12/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodSelectView.h"
#import "TCImageURLSynthesizer.h"
#import "TCGoodSelectTitleView.h"
#import "TCBuluoApi.h"
#import "NSObject+TCModel.h"
#import "TCSelectPrimaryBtn.h"
#import "TCSelectSecondaryBtn.h"
#import "TCSelectButton.h"
#import "TCComponent.h"
#import "UIImage+Category.h"

@implementation TCGoodSelectView {
    TCGoodDetail *goodDetail;
    TCGoodSelectTitleView *selectTitleView;
    UIView *selectView;
    UILabel *numberLab;
    UIView *backView;
    UIView *primaryBtnView;
    UIView *secondaryBtnView;
}

- (instancetype)initWithGoodDetail:(TCGoodDetail *)good {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        goodDetail = good;
        self.hidden = YES;
        [self setupBackView];
        [self setupSelectView];

    }
    
    return self;
}

- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^(void) {
        selectView.y = TCScreenHeight - selectView.height;
    } completion:nil];
}

- (void)close {
    self.hidden = YES;
    [UIView animateWithDuration:0.15 animations:^(void) {
        selectView.y = TCScreenHeight;
    }completion:nil];
}

- (void)setupGoodStandard:(TCGoodStandards *)standards {
    _goodStandard = standards == nil ? [[TCGoodStandards alloc] init] : standards;
    if (standards.descriptions.allKeys.count == 2 && [standards.descriptions[@"secondary"] isEqual:[NSNull null]]) {
        standards.descriptions = @{ @"primary": standards.descriptions[@"primary"] };
    }
    
    
    UIView *standardView = [self getStandardViewWithOrigin:CGPointMake(0, selectTitleView.y + selectTitleView.height) AndGoodStandard:_goodStandard];
    [selectView setHeight:standardView.y + standardView.height];
    [selectView addSubview:standardView];
    
}


- (void)setupBackView {
    backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = TCARGBColor(0, 0, 0, 0.7);
    
    UITapGestureRecognizer *closeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClose)];
    [backView addGestureRecognizer:closeRecognizer];
    [self addSubview:backView];
}

- (void)setupSelectView {
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, 0)];
    selectView.backgroundColor = [UIColor whiteColor];
    
    selectTitleView = [self getTitleViewWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(118))];
    [selectView addSubview:selectTitleView];
    
    UIButton *closeBtn = [TCComponent createImageBtnWithFrame:CGRectMake(TCScreenWidth - TCRealValue(20) - TCRealValue(43 / 2), TCRealValue(24 / 2), TCRealValue(43 / 2), TCRealValue(43 / 2)) AndImageName:@"good_close"];
    [closeBtn addTarget:self action:@selector(touchClose) forControlEvents:UIControlEventTouchUpInside];
    [selectTitleView addSubview:closeBtn];
    
    [self addSubview:selectView];
}

- (UIView *)getCalculateViewWithFrame:(CGRect)frame {
    UIView *calculateView = [[UIView alloc] initWithFrame:frame];
    UILabel *numberTagLab = [[UILabel alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(29), TCRealValue(50), TCRealValue(14))];
    numberTagLab.text = @"数量";
    [calculateView addSubview:numberTagLab];

    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(40), TCRealValue(0.5))];
    [calculateView addSubview:lineView];
    
    UIButton *addBtn = [self createCaculateBtnWithFrame:CGRectMake(frame.size.width - TCRealValue(20) - TCRealValue(38), TCRealValue(20), TCRealValue(38), TCRealValue(35)) AndText:@"+"];
    [addBtn addTarget:self action:@selector(touchAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [calculateView addSubview:addBtn];

    numberLab = [self createBuyNumberLabelWithText:@"1"];
    [calculateView addSubview:numberLab];
    
    UIButton *subBtn = [self createCaculateBtnWithFrame:CGRectMake(numberLab.x - TCRealValue(38), addBtn.y, TCRealValue(38), TCRealValue(35)) AndText:@"-"];
    [subBtn addTarget:self action:@selector(touchSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    [calculateView addSubview:subBtn];

    
    return calculateView;
}

- (UILabel *)createBuyNumberLabelWithText:(NSString *)text {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:TCRealValue(16) AndTextColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFrame:CGRectMake(self.width - TCRealValue(20) - TCRealValue(38) - TCRealValue(58), TCRealValue(20), TCRealValue(58), TCRealValue(35))];
    
    return label;
}


- (UIButton *)createCaculateBtnWithFrame:(CGRect)frame AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
    button.layer.cornerRadius = TCRealValue(3);
    button.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(16)];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}


- (TCGoodSelectTitleView *)getTitleViewWithFrame:(CGRect)frame {
    TCGoodSelectTitleView *titleView = [[TCGoodSelectTitleView alloc] initWithFrame:frame];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(115), TCRealValue(115))];
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goodDetail.mainPicture];
    [titleView.selectImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    titleView.selectPriceLab.text = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", goodDetail.salePrice].floatValue)];
    [titleView setupRepertory:goodDetail.repertory];
    return titleView;
}

- (UIScrollView *)getStandardViewWithOrigin:(CGPoint)point AndGoodStandard:(TCGoodStandards *)goodStandard {
    
    UIScrollView *standardScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(point.x, point.y, TCScreenWidth, TCRealValue(390 / 2))];
    UIView *caculateView = [self getCalculateViewWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(84))];
    [standardScrollView addSubview:caculateView];
    standardScrollView.height = _goodStandard.descriptions.allKeys.count == 1 ? TCRealValue(390 / 2) : TCRealValue(390 / 2 + 84 + 49);
    
    UIView *bottomView = [self getBottomViewWithFrame:CGRectMake(0, standardScrollView.height - TCRealValue(49), TCScreenWidth, TCRealValue(49))];
    [standardScrollView addSubview:bottomView];
    
    if (!(goodStandard.descriptions == nil || goodStandard.descriptions.allKeys.count == 0)) {
        [self setupStandardViewWithGoodStandard:goodStandard AndStandardView:standardScrollView];
        caculateView.y = standardScrollView.height;
        bottomView.y = caculateView.y + caculateView.height;
        [standardScrollView setHeight:bottomView.y + bottomView.height];
    }

    
    return standardScrollView;
}

- (void)setupStandardViewWithGoodStandard:(TCGoodStandards *)goodStandard AndStandardView:(UIScrollView *)standardScrollView {
    UIView *primaryView = [self getStandardDetailViewWithOrigin:CGPointMake(0, 0) AndStandard:goodStandard.descriptions[@"primary"] AndType:@"primary"];
    if (primaryView.height > TCRealValue(390 / 2)) {
        standardScrollView.size = CGSizeMake(TCScreenWidth, primaryView.y + primaryView.height);
    }
    [standardScrollView addSubview:primaryView];
    if (goodStandard.descriptions.allKeys.count == 2) {
        UIView *secondaryView = [self getStandardDetailViewWithOrigin:CGPointMake(0, primaryView.y + primaryView.height) AndStandard:goodStandard.descriptions[@"secondary"] AndType:@"secondary"];
        [standardScrollView addSubview:secondaryView];
        standardScrollView.size = CGSizeMake(TCScreenWidth, secondaryView.y + secondaryView.height);
    }
}

- (UIView *)getStandardDetailViewWithOrigin:(CGPoint)point AndStandard:(NSDictionary *)standardDic AndType:(NSString *)type{
    UIView *standardDetailView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, TCScreenWidth, 0)];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(0.5))];
    [standardDetailView addSubview:topLineView];
    standardDic = [standardDic isEqual:[NSNull null]] ? @{ @"label":@"无", @"types":@[] } : standardDic;
    UILabel *titleLab = [self getStandardDetailTitleLabWithFrame:CGRectMake(TCRealValue(20), TCRealValue(20), TCScreenWidth - 40, TCRealValue(14)) AndText:standardDic[@"label"]];
    [standardDetailView addSubview:titleLab];
    
    UIView *standardBtnView = [self getStandardDetailButtonViewWithOrgin:CGRectMake(TCRealValue(20), titleLab.y + titleLab.height + TCRealValue(20), TCScreenWidth - TCRealValue(40), TCRealValue(49 / 2)) AndTypes:standardDic[@"types"] AndType:type];
    [standardDetailView addSubview:standardBtnView];
    
    [standardDetailView setHeight:standardBtnView.y + standardBtnView.height + TCRealValue(20)];
    
    return standardDetailView;
}

- (UIView *)getStandardDetailButtonViewWithOrgin:(CGRect)frame AndTypes:(NSArray *)types AndType:(NSString *)type {
    
    if ([type isEqualToString:@"primary"]) {
        primaryBtnView = [self getButtonViewWithFrame:frame AndTypes:types AndSpace:TCRealValue(13) AndType:@"primary"];
        return primaryBtnView;
    } else {
        secondaryBtnView = [self getButtonViewWithFrame:frame AndTypes:types  AndSpace:TCRealValue(11) AndType:@"secondary"];
        return secondaryBtnView;
    }
    
    
}

- (UIView *)getButtonViewWithFrame:(CGRect)frame AndTypes:(NSArray *)types AndSpace:(CGFloat)space AndType:(NSString *)type{
    UIView *btnView = [[UIView alloc] initWithFrame:frame];
    int width = 0;
    int height = 0;
    for (int i = 0; i < types.count; i++) {
        TCSelectButton *button = [type isEqualToString:@"primary"] ? [self getPrimaryButtonWithOrigin:CGPointMake(width, height) AndText:types[i]] : [self getSecondaryButtonWithOrigin:CGPointMake(width, height) AndText:types[i]];
        if (width + button.width > btnView.width) {
            width = 0;
            height += TCRealValue(button.height + TCRealValue(7));
            [button setOrigin:CGPointMake(width, height)];
            [btnView setHeight:height + button.height];
        }
        width += button.width + space;
        [btnView addSubview:button];
    }
    return btnView;
}



- (TCSelectPrimaryBtn *)getPrimaryButtonWithOrigin:(CGPoint)point AndText:(NSString *)text {
    TCSelectPrimaryBtn *button = [[TCSelectPrimaryBtn alloc] initWithFrame:CGRectMake(point.x, point.y, 0, 0) AndTitle:text];
    [button addTarget:self action:@selector(touchPrimaryBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (_goodStandard.descriptions.allKeys.count == 1) {
        if (![_goodStandard.goodsIndexes.allKeys containsObject:text]) {
            button.isEffective = NO;
        }
    }
    return button;
}

- (TCSelectSecondaryBtn *)getSecondaryButtonWithOrigin:(CGPoint)point AndText:(NSString *)text {
    TCSelectSecondaryBtn *button = [[TCSelectSecondaryBtn alloc] initWithFrame:CGRectMake(point.x, point.y, 0, 0) AndTitle:text];
    [button addTarget:self action:@selector(touchSecondaryBtn:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)getBottomViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIButton *shopcarBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) AndTitle:@"加入购物车" AndFontSize:TCRealValue(17)];
    [shopcarBtn addTarget:self action:@selector(touchAddShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [shopcarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopcarBtn.backgroundColor = [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1];
    [view addSubview:shopcarBtn];
    
    return view;
}


- (UILabel *)getStandardDetailTitleLabWithFrame:(CGRect)frame AndText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(14)];
    
    return label;
}

- (void)changeSelectBtn:(TCSelectButton *)btn {
    for (int i = 0; i < btn.superview.subviews.count; i++) {
        TCSelectButton *button = btn.superview.subviews[i];
        if (button.isEffective) {
            button.isSelected = NO;
        }
    }
    btn.isSelected = YES;
}

- (void)changeEffectiveBtnWithSuperView:(UIView *)superView IsPrimary:(BOOL)isPrimary{
    for (int i = 0; i < superView.subviews.count; i++) {
        if ([superView.subviews[i] isKindOfClass:[TCSelectButton class]]) {
            TCSelectButton *button = superView.subviews[i];
            NSString *index = isPrimary ? [NSString stringWithFormat:@"%@^%@", [button titleForState:UIControlStateNormal], selectTitleView.selectSecondaryLab.text] : [NSString stringWithFormat:@"%@^%@", selectTitleView.selectPrimaryLab.text, [button titleForState:UIControlStateNormal]];
            if (![_goodStandard.goodsIndexes.allKeys containsObject:index]) {
                button.isEffective = NO;
            } else {
                button.isEffective = YES;
            }
        }
    }
}

- (void)changeGoodDetailWithIndex:(NSString *)index {
    
    goodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:_goodStandard.goodsIndexes[index]];
    
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(115), TCRealValue(115))];
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goodDetail.mainPicture];
    [selectTitleView.selectImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    selectTitleView.selectPriceLab.text = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", goodDetail.salePrice].floatValue)];
    
    [selectTitleView setupRepertory:goodDetail.repertory];
    
    [self changeStandardButton];
}

- (void)touchClose {
    [self close];
}

- (void)touchPrimaryBtnWhenNotSelected:(TCSelectButton *)btn {
    if (_goodStandard.descriptions.allKeys.count == 1) {
        [self changeGoodDetailWithIndex:[btn titleForState:UIControlStateNormal]];
        [self changeSelectBtn:btn];
        [selectTitleView setupPrimary:[btn titleForState:UIControlStateNormal]];
    } else {
        if (![selectTitleView.selectSecondaryLab.text isEqualToString:@""]) {
            [self changeGoodDetailWithIndex:[NSString stringWithFormat:@"%@^%@", [btn titleForState:UIControlStateNormal], selectTitleView.selectSecondaryLab.text]];
        }
        [selectTitleView setupPrimary:[btn titleForState:UIControlStateNormal]];
        [self changeEffectiveBtnWithSuperView:secondaryBtnView IsPrimary:NO ];
        [self changeSelectBtn:btn];
    }
}

- (void)touchSecondaryBtnWhenNotSelected:(TCSelectButton *)btn {
    if (![selectTitleView.selectPrimaryLab.text isEqualToString:@""]) {
        [self changeGoodDetailWithIndex:[NSString stringWithFormat:@"%@^%@", selectTitleView.selectPrimaryLab.text, [btn titleForState:UIControlStateNormal]]];
    }
    [selectTitleView setupSecondary:[btn titleForState:UIControlStateNormal]];
    [self changeEffectiveBtnWithSuperView:primaryBtnView IsPrimary:YES];
    [self changeSelectBtn:btn];
}

- (void)touchPrimaryBtnWhenIsSelected:(TCSelectButton *)btn {
    btn.isSelected = NO;
    [selectTitleView setupPrimary:@""];
    for (int i = 0; i < secondaryBtnView.subviews.count; i++) {
        TCSelectButton *selectBtn = secondaryBtnView.subviews[i];
        selectBtn.isEffective = YES;
    }
}

- (void)touchSecondaryBtnWhenIsSelected:(TCSelectButton *)btn {
    btn.isSelected = NO;
    [selectTitleView setupSecondary:@""];
    for (int i = 0; i < primaryBtnView.subviews.count; i++) {
        TCSelectButton *selectBtn = primaryBtnView.subviews[i];
        selectBtn.isEffective = YES;
    }
}

- (void)touchPrimaryBtn:(TCSelectPrimaryBtn *)btn {
    if (btn.isSelected) {
        [self touchPrimaryBtnWhenIsSelected:btn];
    } else {
        if (btn.isEffective) {
            [self touchPrimaryBtnWhenNotSelected:btn];
        }
    }
}

- (void)touchSecondaryBtn:(TCSelectSecondaryBtn *)btn {
    if (btn.isSelected) {
        [self touchSecondaryBtnWhenIsSelected:btn];
    } else {
        if (btn.isEffective) {
            [self touchSecondaryBtnWhenNotSelected:btn];
        }
    }
    
}

- (void)touchSubBtn:(UIButton *)button {
    NSInteger number = numberLab.text.integerValue;
    if (number <= 1) {
        [MBProgressHUD showHUDWithMessage:@"不能再减了"];
    } else {
        number--;
        numberLab.text = [NSString stringWithFormat:@"%li", (long)number];
    }
}

- (void)touchAddBtn:(UIButton *)button {
    NSInteger number = numberLab.text.integerValue;
    if (number >= selectTitleView.getRepertory) {
        [MBProgressHUD showHUDWithMessage:@"库存不足"];
    } else {
        number++;
        numberLab.text = [NSString stringWithFormat:@"%li", (long)number];
    }
}

- (void)changeStandardButton {
    if (_delegate && [_delegate respondsToSelector:@selector(selectView:didChangeStandardButtonWithGoodDetail:)]) {
        [_delegate selectView:self didChangeStandardButtonWithGoodDetail:goodDetail];
    }
}

- (void)touchAddShoppingCart {
    if (_goodStandard.descriptions.allKeys.count == 1) {
        if ([selectTitleView.selectPrimaryLab.text isEqualToString:@""]) {
            [MBProgressHUD showHUDWithMessage:@"请选择完整的规格"];
            return;
        }
    }
    if (_goodStandard.descriptions.allKeys.count == 2) {
        if ([selectTitleView.selectPrimaryLab.text isEqualToString:@""] || [selectTitleView.selectSecondaryLab.text isEqualToString:@""]) {
            [MBProgressHUD showHUDWithMessage:@"请选择完整的规格"];
            return;
        }
    }
    
    NSInteger amount = numberLab.text.integerValue;
    if (_delegate && [_delegate respondsToSelector:@selector(selectView:didAddShoppingCartWithGoodDetail:Amount:)]) {
        [_delegate selectView:self didAddShoppingCartWithGoodDetail:goodDetail Amount:amount];
        [self close];
    }

}


@end
