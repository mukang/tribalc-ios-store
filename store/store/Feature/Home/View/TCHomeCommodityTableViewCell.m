//
//  TCHomeCommodityTableViewCell.m
//  individual
//
//  Created by WYH on 16/12/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeCommodityTableViewCell.h"
#import "TCComponent.h"

@implementation TCHomeCommodityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TCBackgroundColor;
        
        [self setupLeftView];
        
        [self setupRightTopView];
        
        [self setupRightDownView];
    }
    
    return self;
}

- (void)setupLeftView {
    _leftImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth * 0.442, TCRealValue(150))];
    _leftImgBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_leftImgBtn];
    
    _leftTitleLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), TCRealValue(16.5), _leftImgBtn.width - TCRealValue(20), TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:@""];
    _leftTitleLab.textColor = TCBlackColor;
    [_leftImgBtn addSubview:_leftTitleLab];
}

- (void)setupRightTopView {
    _rightTopImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftImgBtn.x + _leftImgBtn.width + TCScreenWidth * 0.005, 0, TCScreenWidth * 0.553, TCRealValue(74))];
    _rightTopImgBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_rightTopImgBtn];
    
    _rightTopTitleLab = [self getRightTitleLab];
    [_rightTopImgBtn addSubview:_rightTopTitleLab];
    
    _rightTopSubTitleLab = [self getRightSubTitleLab];
    [_rightTopImgBtn addSubview:_rightTopSubTitleLab];
}

- (void)setupRightDownView {
    _rightDownImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftImgBtn.x + _leftImgBtn.width + TCScreenWidth * 0.005, _rightTopImgBtn.y + _rightTopImgBtn.height + 2, TCScreenWidth * 0.553, TCRealValue(74))];
    _rightDownImgBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_rightDownImgBtn];
    
    _rightDownTitleLab = [self getRightTitleLab];
    [_rightDownImgBtn addSubview:_rightDownTitleLab];
    
    _rightDownSubTitleLab = [self getRightSubTitleLab];
    [_rightDownImgBtn addSubview:_rightDownSubTitleLab];
}

- (UILabel *)getRightTitleLab {
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(26.5), TCRealValue(16.5), TCScreenWidth * 0.553 - 26.5, TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:@""];
    label.textColor = TCBlackColor;
    
    return label;
}

- (UILabel *)getRightSubTitleLab {
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(26.5), TCRealValue(31.5), TCScreenWidth * 0.553 - TCRealValue(26.5), TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:@""];
    label.textColor = TCGrayColor;
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
