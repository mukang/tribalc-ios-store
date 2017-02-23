//
//  TCRestaurantTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantTableViewCell.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"

@implementation TCRestaurantTableViewCell  {
    UIView *locationLineType;
    UILabel *priceTagLab;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"serviceListCell";
    TCRestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCRestaurantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIImageView *resImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:resImgView];
        self.resImgView = resImgView;
        
        UILabel *nameLab = [self createLabWithFrame:CGRectNull AndFontSize:TCRealValue(14)];
        nameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *locationLab = [self createLabWithFrame:CGRectNull AndFontSize:TCRealValue(12)];
        [self.contentView addSubview:locationLab];
        self.markPlcaeLab = locationLab;
        
        UILabel *typeLab = [self createLabWithFrame:locationLab.frame AndFontSize:TCRealValue(12)];
        [self.contentView addSubview:typeLab];
        self.typeLab = typeLab;
        
        UILabel *priceLab = [self getPriceLab];
        [self.contentView addSubview:priceLab];
        self.priceLab = priceLab;
        
        UILabel *rangeLab = [self getRangeLab];
        [self.contentView addSubview:rangeLab];
        self.rangeLab = rangeLab;
        
        UIImageView *roomImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:roomImgView];
        self.roomLogoView = roomImgView;
        
        UIImageView *reserveImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:reserveImgView];
        self.reserveLogoView = reserveImgView;
        
        
        locationLineType = [self getCenterLineWithFrame:CGRectNull];
        [self.contentView addSubview:locationLineType];
        
        priceTagLab = [self createLabWithFrame:CGRectNull AndFontSize:TCRealValue(12)];
        [self.contentView addSubview:priceTagLab];

        

        
    }
    return self;
}


- (void)setService:(TCService *)service {
    _service = service;
    [self setupData];
    [self setupFrame];
    
}

- (void)setupData {
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:_service.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(175), TCRealValue(130))];
    [self.resImgView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    self.nameLab.text = _service.name;
    self.markPlcaeLab.text = _service.store.markPlace;
    if (_service.tags.count != 0) {
        self.typeLab.text = _service.tags[0];
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", _service.personExpense].floatValue)];
    self.rangeLab.text = @"233m";
    [self setupLogoImageData];
    
}

- (void)setupLogoImageData {
    if(_service.reservable) {
        self.reserveLogoView.image = [UIImage imageNamed:@"res_reserve"];
    } else {
        self.reserveLogoView.image = [UIImage imageNamed:@""];
    }
    BOOL isRoom = YES;
    if (isRoom) {
        self.roomLogoView.image = [UIImage imageNamed:@"res_room"];
    } else {
        self.roomLogoView.image = [UIImage imageNamed:@""];
    }
}

- (void)setupFrame {
    self.resImgView.frame = CGRectMake(TCRealValue(20), TCRealValue(160) / 2 - TCRealValue(130) / 2, TCRealValue(175), TCRealValue(130));
    self.nameLab.frame = CGRectMake(_resImgView.origin.x + _resImgView.size.width + TCRealValue(17), _resImgView.origin.y + TCRealValue(2), TCScreenWidth - _resImgView.origin.x - _resImgView.size.width - TCRealValue(17), TCRealValue(15));
    [self setupMarkPlaceAndBrandFrame];
    [self setupPriceFrame];
    
    self.rangeLab.frame = CGRectMake(TCScreenWidth - TCRealValue(80) - TCRealValue(20), TCRealValue(320 / 2) - TCRealValue(30 / 2) - TCRealValue(12), TCRealValue(80), TCRealValue(15));
    [self setupLogoImageFrame];
}

- (void)setupMarkPlaceAndBrandFrame {
    self.markPlcaeLab.frame = CGRectMake(_nameLab.origin.x + TCRealValue(2), _nameLab.y + _nameLab.height + TCRealValue(11), 0, TCRealValue(12));
    [self.markPlcaeLab sizeToFit];
    locationLineType.frame = CGRectMake(self.markPlcaeLab.x + self.markPlcaeLab.width + TCRealValue(2), self.markPlcaeLab.y + TCRealValue(1.5), TCRealValue(1), TCRealValue(11));
    if (_service.tags.count == 0) {
        locationLineType.frame = CGRectNull;
    }
    self.typeLab.frame = CGRectMake(locationLineType.x + TCRealValue(3), self.markPlcaeLab.y, 0, 0);
    [self.typeLab sizeToFit];
}

- (void)setupPriceFrame {
    self.priceLab.frame = CGRectMake(self.nameLab.x, TCRealValue(160) - TCRealValue(120 / 2) + 1, 0, 0);
    [self.priceLab sizeToFit];
    priceTagLab.frame = CGRectMake(self.priceLab.x + self.priceLab.width, self.priceLab.y + TCRealValue(19 - 12), TCRealValue(80), TCRealValue(12));
    priceTagLab.text = @"元/人";
}

- (void)setupLogoImageFrame {
    if (_service.reservable) {
        self.reserveLogoView.frame = CGRectMake(self.nameLab.x + TCRealValue(5), self.priceLab.y + self.priceLab.height + TCRealValue(12 / 2), TCRealValue(16), TCRealValue(16));
        self.roomLogoView.frame = CGRectMake(self.reserveLogoView.x + self.reserveLogoView.width + TCRealValue(12), self.reserveLogoView.y, TCRealValue(16), TCRealValue(16));
    } else {
        self.roomLogoView.frame =  CGRectMake(self.nameLab.x + TCRealValue(5), self.priceLab.y + self.priceLab.height + TCRealValue(12 / 2), TCRealValue(16), TCRealValue(16));
    }
}


- (UIView *)getCenterLineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    return line;
}



- (UIImageView *)createImageViewWithFrame:(CGRect)frame AndImageName:(NSString *)imgName {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:imgName];
    imgView.image = img;
    return imgView;
}

- (UILabel *)getPriceLab {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:TCRealValue(19)];
    
    return label;
}


- (UILabel *)getRangeLab {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:TCRealValue(12)];
    
    return label;
}

- (void)initialImgView {
    
    [self.contentView addSubview:_resImgView];
}

- (UILabel *)createLabWithFrame:(CGRect)frame AndFontSize:(float)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:font];
    label.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    
    return label;
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
