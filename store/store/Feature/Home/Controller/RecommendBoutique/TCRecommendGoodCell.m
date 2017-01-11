//
//  TCRecommendGoodCell.m
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendGoodCell.h"

@implementation TCRecommendGoodCell {

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self createGoodImageView];
        [self createGoodTypeAndNameLab];
        [self createGoodShopLab];
        [self createGoodPriceLab];
        [self createCollectionLogoImgView];
        
    }
    return self;
}


- (void)createGoodImageView {
    _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, TCRealValue(428 / 2))];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodImageView];
}

- (void)createGoodTypeAndNameLab {
    _typeAndNameLab = [self initialWithFrame:CGRectMake(_goodImageView.frame.origin.x + TCRealValue(8), _goodImageView.frame.origin.y + _goodImageView.frame.size.height + TCRealValue(11), _goodImageView.frame.size.width - TCRealValue(16), TCRealValue(14))];
    
    _typeAndNameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
    [self.contentView addSubview:_typeAndNameLab];
}

- (void)createGoodShopLab {
    _shopNameLab = [self initialWithFrame:CGRectMake(_typeAndNameLab.frame.origin.x + TCRealValue(1), _typeAndNameLab.frame.origin.y + _typeAndNameLab.frame.size.height + TCRealValue(11), _goodImageView.frame.size.width, TCRealValue(12))];
    _shopNameLab.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [self.contentView addSubview:_shopNameLab];

}

- (void)createGoodPriceLab {
    _priceLab = [self initialWithFrame:CGRectMake(_shopNameLab.frame.origin.x - TCRealValue(1), _shopNameLab.y + _shopNameLab.height + TCRealValue(7), _goodImageView.frame.size.width, TCRealValue(16))];
    _priceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(16)];
    [self.contentView addSubview:_priceLab];
}

- (void)createCollectionLogoImgView {
    _collectionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - TCRealValue(8) - TCRealValue(16), self.height - TCRealValue(8) - TCRealValue(16), TCRealValue(16), TCRealValue(16))];
    UIImage *collectionImg = [UIImage imageNamed:@"good_collection_no"];
    _collectionImgView.image = collectionImg;
    [_goodImageView addSubview:_collectionImgView];
    _collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(_collectionImgView.x - TCRealValue(5), _collectionImgView.y - TCRealValue(5), _collectionImgView.width + TCRealValue(10), _collectionImgView.width + TCRealValue(10))];
    [self.contentView addSubview:_collectionBtn];
}




- (UILabel *)initialWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:TCRealValue(12)];
    label.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    return label;
}


@end
