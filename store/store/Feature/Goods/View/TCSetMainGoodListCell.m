//
//  TCSetMainGoodListCell.m
//  store
//
//  Created by 王帅锋 on 17/2/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSetMainGoodListCell.h"
#import <Masonry.h>

@interface TCSetMainGoodListCell ()

@property (strong, nonatomic) UIButton *titleBtn;

@property (strong, nonatomic) UIImageView *imageV;

@end

@implementation TCSetMainGoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setSelect:(BOOL)select {
    if (select) {
        [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleBtn setBackgroundColor:TCRGBColor(252, 108, 38)];
        self.imageV.image = [UIImage imageNamed:@"mainGoodSelected"];
    }else {
        [self.titleBtn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
        [self.titleBtn setBackgroundColor:TCRGBColor(242, 242, 242)];
        self.imageV.image = [UIImage imageNamed:@"mainGoodUnselect"];
    }
}


- (void)setUpUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleBtn];
    [self.contentView addSubview:self.imageV];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.top.equalTo(self.contentView).offset(9);
        make.bottom.equalTo(self.contentView).offset(-9);
        make.width.lessThanOrEqualTo(@(TCScreenWidth-110));
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-30);
        make.width.height.equalTo(@20);
    }];
}

- (UIButton *)titleBtn {
    if (_titleBtn == nil) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
        _titleBtn.layer.cornerRadius = 10.0;
        _titleBtn.userInteractionEnabled = NO;
        _titleBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 30);
        _titleBtn.clipsToBounds = YES;
        [_titleBtn setBackgroundColor:TCRGBColor(242, 242, 242)];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleBtn.titleLabel.numberOfLines = 0;
    }
    return _titleBtn;
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"mainGoodUnselect"];
    }
    return _imageV;
}

- (void)setTitleStr:(NSString *)titleStr {
    if (_titleStr != titleStr) {
        _titleStr = titleStr;
        
        [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
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
