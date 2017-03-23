//
//  TCGoodsStandardListCell.m
//  store
//
//  Created by 王帅锋 on 17/1/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardListCell.h"
#import "TCGoodsStandardMate.h"
#import "TCGoodStandards.h"
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

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


- (void)setGoodsStandard:(TCGoodStandards *)goodsStandard {
    if (_goodsStandard != goodsStandard) {
        _goodsStandard = goodsStandard;
        
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        NSDictionary *dict = goodsStandard.goodsIndexes;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray *arr = dict.allValues;
            if (arr) {
                if (arr.count) {
                    CGFloat width = 108.0;
                    CGFloat height = 117.0;
                    for (int i = 0; i < arr.count; i++) {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15+(width+5)*i, 15, width, height)];
                        [self.scrollView addSubview:imageView];
                        imageView.layer.cornerRadius = 3.0;
                        imageView.clipsToBounds = YES;
                        
                        NSDictionary *dict = arr[i];
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            NSArray *arr = dict[@"pictures"];
                            if ([arr isKindOfClass:[NSArray class]]) {
                                if (arr.count) {
                                    NSString *str = arr[0];
                                    if ([str isKindOfClass:[NSString class]]) {
                                        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:str];
                                        UIImage *placeholderImage = [UIImage placeholderImageWithSize:imageView.size];
                                        [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
                                    }
                                }
                            }
                        }
                    }
                    [self.scrollView setContentSize:CGSizeMake(25+(width+5)*arr.count, 0)];
                }
            }
        }
    }
}

- (void)setUpViews {
    _titleL = [[UILabel alloc] init];
    _titleL.font = [UIFont systemFontOfSize:14];
    _titleL.textColor = TCBlackColor;
    _titleL.numberOfLines = 0;
    [self.contentView addSubview:_titleL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    self.btn = btn;
    
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor =TCLightGrayColor;
    _lineView = lineView;
    lineView.hidden = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.hidden = YES;
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(14);
        make.width.equalTo(@(TCScreenWidth-115));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.height.equalTo(@15);
    }];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2 : 3;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@(1/scale));
        make.top.equalTo(_titleL.mas_bottom).offset(15);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@168);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.btn.selected = !self.btn.selected;
    
    if (self.btn.selected) {
        [self.btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        
        if (self.goodsStandardMate.descriptions) {
            self.scrollView.hidden = NO;
            self.lineView.hidden = NO;
            
            [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(25);
            }];
            
            
//            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@118);
//            }];
//            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@0.5);
//            }];
        }else {
            self.scrollView.hidden = YES;
            self.lineView.hidden = YES;
            
            [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(15);
            }];
            
//            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@0);
//            }];
//            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@0);
//            }];
        }
        
    }else {
        [self.btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
        self.scrollView.hidden = YES;
        self.lineView.hidden = YES;
        
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
        }];
        
//        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
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
//    if (_select != select) {
        _select = select;
        self.btn.selected = select;
        if (select) {
            [self.btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            if (self.goodsStandardMate.descriptions) {
                self.scrollView.hidden = NO;
                self.lineView.hidden = NO;
                
                [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView).offset(25);
                }];
                
//                [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@118);
//                }];
//                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0.5);
//                }];
            }else {
                self.scrollView.hidden = YES;
                self.lineView.hidden = YES;
                [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView).offset(15);
                }];
//                [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
//                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(@0);
//                }];
            }
        }else {
            [self.btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
            self.scrollView.hidden = YES;
            self.lineView.hidden = YES;
            [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(15);
            }];
//            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@0);
//            }];
//            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@0);
//            }];
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
//    }
}


- (void)setGoodsStandardMate:(TCGoodsStandardMate *)goodsStandardMate {
    if (_goodsStandardMate != goodsStandardMate) {
        _goodsStandardMate = goodsStandardMate;
        _titleL.text = goodsStandardMate.title;
    }
}

@end
