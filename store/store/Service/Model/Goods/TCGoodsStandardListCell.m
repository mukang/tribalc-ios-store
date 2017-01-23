//
//  TCGoodsStandardListCell.m
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardListCell.h"
#import "TCGoodsStandardMate.h"

@interface TCGoodsStandardListCell ()

@property (strong, nonatomic) UILabel *titleL;

@end

@implementation TCGoodsStandardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    _titleL = [[UILabel alloc] init];
    _titleL.font = [UIFont systemFontOfSize:14];
    _titleL.textColor = TCRGBColor(42, 42, 42);
    _titleL.numberOfLines = 0;
    [self.contentView addSubview:_titleL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(14);
        make.width.equalTo(@(TCScreenWidth-115));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.height.equalTo(@15);
    }];
}

- (void)setGoodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate {
    if (_goodsStandardMate != goodsStandardMate) {
        _goodsStandardMate = goodsStandardMate;
        _titleL.text = goodsStandardMate.title;
    }
}

@end
