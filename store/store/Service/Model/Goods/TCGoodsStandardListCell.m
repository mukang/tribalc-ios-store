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

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *lineView;

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
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    self.btn = btn;
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = TCRGBColor(154, 154, 154);
    _lineView = lineView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor redColor];
    self.scrollView = scrollView;
    scrollView.hidden = YES;
    
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
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@0);
        make.top.equalTo(_titleL.mas_bottom).offset(15);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.btn.selected = !self.btn.selected;
    
    if (self.btn.selected) {
        [self.btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        
        if (self.goodsStandardMate.descriptions) {
            self.scrollView.hidden = NO;
            self.lineView.hidden = NO;
            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@118);
            }];
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
            }];
        }else {
            self.scrollView.hidden = YES;
            self.lineView.hidden = YES;
            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
        
    }else {
        [self.btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
        self.scrollView.hidden = YES;
        self.lineView.hidden = YES;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didClick:selected:)]) {
            [self.delegate didClick:self selected:self.btn.selected];
        }
    }
}

- (void)setSelect:(BOOL)select {
    if (_select != select) {
        _select = select;
        self.btn.selected = select;
        if (select) {
            [self.btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            if (self.goodsStandardMate.descriptions) {
                self.scrollView.hidden = NO;
                self.lineView.hidden = NO;
                [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@118);
                }];
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0.5);
                }];
            }else {
                self.scrollView.hidden = YES;
                self.lineView.hidden = YES;
                [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }
        }else {
            [self.btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
            self.scrollView.hidden = YES;
            self.lineView.hidden = YES;
            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}


- (void)setGoodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate {
    if (_goodsStandardMate != goodsStandardMate) {
        _goodsStandardMate = goodsStandardMate;
        _titleL.text = goodsStandardMate.title;
    }
}

@end
