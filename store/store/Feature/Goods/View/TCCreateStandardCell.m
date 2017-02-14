//
//  TCCreateStandardCell.m
//  store
//
//  Created by 王帅锋 on 17/1/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateStandardCell.h"
#import <Masonry.h>
#import "MBProgressHUD+Category.h"
#import "TCGoodsStandardKeysBtn.h"

@interface TCCreateStandardCell ()<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *addBtn;

@property (assign, nonatomic) CGFloat cellHeight;

@property (strong, nonatomic) UIView *labelsView;

@end

@implementation TCCreateStandardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"standardDelete"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(186, 186, 186);
    [self.contentView addSubview:lineView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = TCRGBColor(42, 42, 42);
    [self.contentView addSubview:_titleLabel];
    
    _standardNameTextField = [[UITextField alloc] init];
    _standardNameTextField.delegate = self;
    _standardNameTextField.font = [UIFont systemFontOfSize:14];
    _standardNameTextField.placeholder = @"  输入名称，如颜色";
    _standardNameTextField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    _standardNameTextField.layer.cornerRadius = 3.0;
    _standardNameTextField.tag = 111;
    _standardNameTextField.clipsToBounds = YES;
    _standardNameTextField.layer.borderWidth = 0.5;
    [self.contentView addSubview:_standardNameTextField];
    
    _standardContentTextField = [[UITextField alloc] init];
    _standardContentTextField.font = [UIFont systemFontOfSize:14];
    _standardContentTextField.placeholder = @"  请输入商品标签，用“、”隔开";
    _standardContentTextField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    _standardContentTextField.layer.cornerRadius = 3.0;
    _standardContentTextField.tag = 222;
    _standardContentTextField.delegate = self;
    _standardContentTextField.clipsToBounds = YES;
    _standardContentTextField.layer.borderWidth = 0.5;
    [self.contentView addSubview:_standardContentTextField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 27, 34);
    [btn setImage:[UIImage imageNamed:@"rightAdd"] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    _standardContentTextField.rightView = btn;
    [btn addTarget:self action:@selector(addStandard) forControlEvents:UIControlEventTouchUpInside];
    _standardContentTextField.rightViewMode = UITextFieldViewModeAlways;
    
    _labelsView = [[UIView alloc] init];
    [self.contentView addSubview:_labelsView];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn addTarget:self action:@selector(addSecondaryStandard) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    
    UIImageView *addImage = [[UIImageView alloc] init];
    addImage.image = [UIImage imageNamed:@"addSecondary"];
    [_addBtn addSubview:addImage];
    
    UILabel *l = [[UILabel alloc] init];
    l.text = @"添加二级规格";
    l.font = [UIFont systemFontOfSize:12];
    l.textColor = TCRGBColor(42, 42, 42);
    [_addBtn addSubview:l];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(@28);
    }];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2 : 3;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deleteBtn.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(1/scale));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(lineView).offset(15);
        make.height.equalTo(@34);
        make.width.equalTo(@60);
    }];
    
    [_standardNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.top.equalTo(_titleLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@34);
    }];
    
    [_standardContentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(_standardNameTextField.mas_bottom).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(_standardNameTextField);
    }];
    
    [_labelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_standardContentTextField.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0);
    }];
    
   
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_labelsView.mas_bottom);
        make.height.equalTo(@45);
        make.width.equalTo(@120);
    }];
    
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addBtn).offset(10);
        make.top.equalTo(_addBtn).offset(10);
        make.width.height.equalTo(@15);
    }];
    
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addImage.mas_right).offset(5);
        make.right.equalTo(_addBtn).offset(-10);
        make.top.height.equalTo(addImage);
    }];
    
    _cellHeight = 191.0;
}

- (void)delete {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(deleteCurrentCell:)]) {
            [self.delegate deleteCurrentCell:self];
        }
    }
}

- (void)hideAddBtn {
    [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    _addBtn.hidden = YES;
    
    _cellHeight -= 45.0;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)showAddBtn {
    [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
    }];
    
    _addBtn.hidden = NO;
    
    _cellHeight += 45.0;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)addSecondaryStandard {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(addSecondaryStandardCell)]) {
            [self.delegate addSecondaryStandardCell];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldShouldReturnn)]) {
            [self.delegate textFieldShouldReturnn];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditting:)]) {
            [self.delegate textFieldShouldBeginEditting:self];
        }
    }
    
    if (textField.tag == 222) {
        if (_standardNameTextField.text.length == 0) {
            [MBProgressHUD showHUDWithMessage:@"请输入规格名称"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditting:)]) {
            [self.delegate textFieldShouldEndEditting:self];
        }
    }
    return YES;
}

- (void)setCurrentStandards:(NSArray *)currentStandards {
    if (_currentStandards != currentStandards) {
        _currentStandards = currentStandards;
        
        for (UIView *view in _labelsView.subviews) {
            [view removeFromSuperview];
        }
        
        if (currentStandards.count > 0) {
            for (int i = 0; i < currentStandards.count; i++) {
                TCGoodsStandardKeysBtn *btn = [TCGoodsStandardKeysBtn buttonWithType:UIButtonTypeCustom];
                [btn setTitle:currentStandards[i] forState:UIControlStateNormal];
                [btn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
                btn.layer.cornerRadius = 3.0;
                btn.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
                btn.layer.borderWidth = 0.5;
                //            btn.clipsToBounds = YES;
                [_labelsView addSubview:btn];
                
                UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleBtn setImage:[UIImage imageNamed:@"libsDelete"] forState:UIControlStateNormal];
                [btn addSubview:deleBtn];
                [deleBtn addTarget:self action:@selector(deleteLibs:) forControlEvents:UIControlEventTouchUpInside];
                deleBtn.frame = CGRectMake((TCScreenWidth - 30 - 2 * 28)/3 - 7, -7, 14, 14);
            }
        }
        
        [self reload];
    }
}

- (void)addStandard {
    
    if (_standardContentTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入规格"];
        return;
    }
    NSString *standardStr = _standardContentTextField.text;
    
    NSArray *arr = [standardStr componentsSeparatedByString:@"、"];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.currentStandards];
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str in arr) {
        if ([str isKindOfClass:[NSString class]]) {
            NSString *newStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([newStr isKindOfClass:[NSString class]]) {
                if (newStr.length) {
                    if (![mutableArr containsObject:newStr]) {
                        [mutArr addObject:newStr];
                    }
                }
            }
        }
    }
    
    [mutableArr addObjectsFromArray:mutArr];
    _currentStandards = mutableArr;
    
    if (mutArr.count > 0) {
        for (int i = 0; i < mutArr.count; i++) {
            TCGoodsStandardKeysBtn *btn = [TCGoodsStandardKeysBtn buttonWithType:UIButtonTypeCustom];
            [btn setTitle:mutArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3.0;
            btn.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
            btn.layer.borderWidth = 0.5;
//            btn.clipsToBounds = YES;
            [_labelsView addSubview:btn];
            
            UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleBtn setImage:[UIImage imageNamed:@"libsDelete"] forState:UIControlStateNormal];
            [btn addSubview:deleBtn];
            [deleBtn addTarget:self action:@selector(deleteLibs:) forControlEvents:UIControlEventTouchUpInside];
            deleBtn.frame = CGRectMake((TCScreenWidth - 30 - 2 * 28)/3 - 7, -7, 14, 14);
        }
    }
    
    [self reload];
    
}

- (void)reload {
    CGFloat labelsViewH = 0.0;
    if (_labelsView.subviews.count > 0) {
        for (int i = 0; i < _labelsView.subviews.count; i++) {
            UIButton *btn = _labelsView.subviews[i];
            int r = i / 3;
            int c = i % 3;
            CGFloat w = (TCScreenWidth - 30 - 2 * 28)/3;
            CGFloat h = 30.0;
            CGFloat margn = 28.0;
            btn.frame = CGRectMake(c * (w + margn), 5+40*r, w, h);
        }
        
        labelsViewH = 10+40*((_labelsView.subviews.count-1)/3 + 1);
    }
    
    [_labelsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(labelsViewH));
    }];
    
    if (_addBtn.hidden) {
        _cellHeight = labelsViewH + 146.0;
    }else {
        _cellHeight = labelsViewH + 191.0;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    _standardContentTextField.text = nil;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(createOrReloadPriceAndRepertoryCell:)]) {
            [self.delegate createOrReloadPriceAndRepertoryCell:self];
        }
    }
}

- (void)deleteLibs:(UIButton *)btn {
    UIButton *button = (UIButton *)(btn.superview);
    NSString *str = button.titleLabel.text;
    NSMutableArray *mutabelArr = [NSMutableArray arrayWithArray: self.currentStandards];
    [mutabelArr removeObject:str];
    [button removeFromSuperview];
    self.currentStandards = mutabelArr;
    
    [self reload];
}

- (CGFloat)cellHeight {
    return _cellHeight;
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
