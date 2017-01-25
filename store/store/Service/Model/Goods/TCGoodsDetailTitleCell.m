//
//  TCGoodsDetailTitleCell.m
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsDetailTitleCell.h"
#import <YYText.h>
#import <Masonry.h>

@interface TCGoodsDetailTitleCell ()<YYTextViewDelegate>

@property (strong, nonatomic) UILabel *numLabel;

@end

@implementation TCGoodsDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    YYTextView *textView = [YYTextView new];
    textView.textColor = TCRGBColor(42, 42, 42);
    textView.font = [UIFont systemFontOfSize:12];
    textView.placeholderFont = [UIFont systemFontOfSize:12];
    textView.placeholderText = @"输入商品详情标题";
    textView.placeholderTextColor = TCRGBColor(186, 186, 186);
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    UILabel *l = [[UILabel alloc] init];
    l.textColor = TCRGBColor(186, 186, 186);
    l.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:l];
    l.textAlignment = NSTextAlignmentRight;
    l.text = @"0/60";
    self.numLabel = l;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(186, 186, 186);
    [self.contentView addSubview:lineView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-65);
        make.height.equalTo(@49.5);
    }];
    
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-12);
        
    }];
    
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(20);
//        make.right.equalTo(self.contentView).offset(-20);
//        make.bottom.equalTo(self.contentView);
//        make.height.equalTo(@0.5);
//    }];
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
