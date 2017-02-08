//
//  TCGoodsListCell.m
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsListCell.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import "TCGoods.h"
#import <UIImageView+WebCache.h>

@interface TCGoodsListCell ()

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *storeLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *salesLabel;

@property (strong, nonatomic) UILabel *creatTimeLabel;

@end

@implementation TCGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _imgView = [[UIImageView alloc] init];
    _imgView.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
    _imgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = TCRGBColor(42, 42, 42);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _storeLabel = [[UILabel alloc] init];
    _storeLabel.textColor = TCRGBColor(154, 154, 154);
    _storeLabel.font = [UIFont systemFontOfSize:13];
    _storeLabel.numberOfLines = 1;
    [self.contentView addSubview:_storeLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = TCRGBColor(154, 154, 154);
    _priceLabel.font = [UIFont systemFontOfSize:13];
    _priceLabel.numberOfLines = 1;
    [self.contentView addSubview:_priceLabel];
    
    _salesLabel = [[UILabel alloc] init];
    _salesLabel.textColor = TCRGBColor(154, 154, 154);
    _salesLabel.font = [UIFont systemFontOfSize:13];
    _salesLabel.numberOfLines = 1;
    [self.contentView addSubview:_salesLabel];
    
    _creatTimeLabel = [[UILabel alloc] init];
    _creatTimeLabel.textColor = TCRGBColor(154, 154, 154);
    _creatTimeLabel.font = [UIFont systemFontOfSize:13];
    _creatTimeLabel.numberOfLines = 1;
    [self.contentView addSubview:_creatTimeLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(30));
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@126);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        make.left.equalTo(_imgView.mas_right).offset(TCRealValue(20));
        make.right.equalTo(self.contentView).offset(-TCRealValue(20));
        make.height.equalTo(@35);
    }];
    
    [_storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(13);
        make.height.equalTo(@15);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_storeLabel);
        make.top.equalTo(_storeLabel.mas_bottom).offset(4);
    }];
    
    [_salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_priceLabel);
        make.top.equalTo(_priceLabel.mas_bottom).offset(4);
    }];
    
    [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_salesLabel);
        make.top.equalTo(_salesLabel.mas_bottom).offset(4);
    }];
}

- (void)setGood:(TCGoods *)good {
    if (_good != good) {
        _good = good;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:good.mainPicture];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:_imgView.size];
        [self.imgView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        
        _titleLabel.text = good.title;
        _storeLabel.text = [NSString stringWithFormat:@"库存  %ld份",good.priceAndRepertory.repertory];
        _priceLabel.text = [NSString stringWithFormat:@"单价  %.2f元",good.priceAndRepertory.salePrice];
        _salesLabel.text = [NSString stringWithFormat:@"销量  %ld",good.saleQuantity];
        _creatTimeLabel.text = @"创建时间  2016-09-09";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
