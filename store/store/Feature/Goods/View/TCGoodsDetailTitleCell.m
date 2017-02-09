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

@property (strong, nonatomic) YYTextView *textView;

@end

@implementation TCGoodsDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setTitle:(NSString *)str {
    _textView.text = str;
}

- (void)setUpViews {
    YYTextView *textView = [YYTextView new];
    textView.textColor = TCRGBColor(42, 42, 42);
    textView.font = [UIFont systemFontOfSize:12];
    textView.placeholderFont = [UIFont systemFontOfSize:12];
    textView.placeholderText = @"输入商品详情标题";
    textView.placeholderTextColor = TCRGBColor(186, 186, 186);
    textView.delegate = self;
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
    
}


- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditting:)]) {
            [self.delegate textViewShouldBeginEditting:textView];
        }
    }
    
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 60)
    {
        textView.text = [str substringToIndex:60];
        self.numLabel.text = @"60/60";
        return YES;
    }
    
    if ([text isEqualToString:@"/n"]) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textViewDidEndEditting:)]) {
            [self.delegate textViewDidEndEditting:textView];
        }
    }

}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0 && textView.text.length <= 60) {
        self.numLabel.text = [NSString stringWithFormat:@"%lu/60", (unsigned long)textView.text.length];
    }else if(textView.text.length == 0) {
        self.numLabel.text = @"0/60";
    }else {

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
