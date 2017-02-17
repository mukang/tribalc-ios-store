//
//  TCSetMainGoodCell.m
//  store
//
//  Created by 王帅锋 on 17/2/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSetMainGoodCell.h"
#import <Masonry.h>

@interface TCSetMainGoodCell ()

@property (strong, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) UILabel *titleL;

@end

@implementation TCSetMainGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setSelect:(BOOL)select {
    if (_select != select) {
        _select = select;
        if (select) {
            self.imageV.image = [UIImage imageNamed:@"mainGoodSelected"];
        }else {
            self.imageV.image = [UIImage imageNamed:@"mainGoodUnselect"];
        }
    }
    
}

- (void)setUpSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.imageV];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@150);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-30);
        make.width.height.equalTo(@20);
    }];
}

- (UILabel *)titleL {
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] init];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = TCRGBColor(42, 42, 42);
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.text = @"设为主商品";
    }
    return _titleL;
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"mainGoodUnselect"];
    }
    return _imageV;
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
