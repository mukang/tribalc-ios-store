//
//  TCGoodShopView.m
//  individual
//
//  Created by WYH on 16/12/19.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodShopView.h"
#import "TCComponent.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"

@implementation TCGoodShopView

- (instancetype)initWithFrame:(CGRect)frame AndShopDetail:(TCGoodDetail *)shopDetail {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *logoImageView = [self createShopLogoImageViewWithFrame:CGRectMake(TCRealValue(20), frame.size.height / 2 - TCRealValue(48 / 2), TCRealValue(48), TCRealValue(48)) AndUrlStr:shopDetail.thumbnail];
        [self addSubview:logoImageView];
        
        UILabel *brandLab = [self createBrandLabWithFrame:CGRectMake(logoImageView.x + logoImageView.width + TCRealValue(12), TCRealValue(8), frame.size.width - logoImageView.width - logoImageView.x - TCRealValue(12), TCRealValue(14)) BrandStr:shopDetail.brand];
        [self addSubview:brandLab];
        
        UIView *evaluateView = [self getEvaluateViewWithFrame:CGRectMake(brandLab.x, brandLab.y + brandLab.height + TCRealValue(4), brandLab.width, TCRealValue(13)) AndEvaluateNumer:5];
        [self addSubview:evaluateView];
        
        UILabel *saleAndProfitLab = [self getSaleAndPhoneNumberLabWithFrame:CGRectMake(brandLab.x, evaluateView.y + evaluateView.height + TCRealValue(5), brandLab.width, TCRealValue(11)) SaleNumber:shopDetail.saleQuantity PhoneNumer:65573];
        [self addSubview:saleAndProfitLab];
        
        
    }
    
    return self;
}

- (UILabel *)getSaleAndPhoneNumberLabWithFrame:(CGRect)frame SaleNumber:(NSInteger)saleNumber PhoneNumer:(NSInteger)phoneNumer {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(11)];
    label.textColor = TCRGBColor(154, 154, 154);
    label.text = [NSString stringWithFormat:@"总销量 : %li   电话 : %li", saleNumber, phoneNumer];
    return label;
}

- (UIView *)getEvaluateViewWithFrame:(CGRect)frame AndEvaluateNumer:(NSInteger)amount{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    NSInteger number = amount;
    for (int i = 0; i < number; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_collection_yes"]];
        [imgView setSize:CGSizeMake(TCRealValue(13), TCRealValue(13))];
        if (i == 0) {
            [imgView setOrigin:CGPointMake(0, 0)];
        } else {
            [imgView setOrigin:CGPointMake(i * TCRealValue(13) + i * TCRealValue(3), 0)];
        }
        [view addSubview:imgView];
    }
    return view;
}



- (UIImageView *)createShopLogoImageViewWithFrame:(CGRect)frame AndUrlStr:(NSString *)urlStr{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:urlStr];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:frame.size];
    [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    return imageView;
}

- (UILabel *)createBrandLabWithFrame:(CGRect)frame BrandStr:(NSString *)brandStr {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(14)];
    label.textColor = TCRGBColor(42, 42, 42);
    label.text = [NSString stringWithFormat:@"品牌 : %@", brandStr];
    
    return label;
}

@end
