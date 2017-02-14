//
//  TCGoodsTipsCell.m
//  store
//
//  Created by 王帅锋 on 17/2/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsTipsCell.h"

@interface TCGoodsTipsCell ()<UITextFieldDelegate>

@property (copy, nonatomic) NSArray *tipsArr;

@property (assign, nonatomic) CGFloat cellHeight;

@property (strong, nonatomic) UIView *libsView;

@property (copy, nonatomic) NSArray *libsArr;

@end

@implementation TCGoodsTipsCell

- (void)setType:(NSString *)type {
    if (_type != type) {
        _type = type;
        
        if ([type isEqualToString:@"FOOD"]) {
            _tipsArr = @[@"休闲食品",@"饮料冲调",@"地方特产",@"中外名酒",@"新鲜水果",@"茗茶"];
        }else if ([type isEqualToString:@"GIFT"]) {
            _tipsArr = @[@"鲜花",@"玉器",@"手工艺品",@"青花瓷",@"水晶",@"刺绣",@"印章",@"雕塑",@"陶瓷",@"琉璃"];
        }else if ([type isEqualToString:@"OFFICE"]) {
            _tipsArr = @[@"办公设备",@"办公耗材",@"传真设备",@"打印机",@"多功能一体机",@"碎纸机",@"考勤机",@"保险柜",@"办公家具",@"办公文具",@"文件管理",@"财会用品"];
        }else if ([type isEqualToString:@"MAKEUP"]) {
            _tipsArr = @[@"面部护理",@"身体护理",@"口腔护理",@"香水",@"彩妆",@"洗发护发",@"敏感可用",@"睫毛膏",@"油性肌肤",@"干性肌肤",@"无酒精",@"纯植物"];
        }else if ([type isEqualToString:@"PENETRATION"]) {
            _tipsArr = @[@"白金卡",@"VIP卡",@"会员卡",@"黑金卡"];
        }else if ([type isEqualToString:@"HOUSE"]) {
            _tipsArr = @[@"收纳用品",@"布艺软饰",@"抱枕靠垫",@"床上用品",@"毯子",@"家纺",@"浴室用品",@"净化除味",@"装饰字画",@"地毯地垫",@"灯具",@"创意家具",@"花瓶花艺"];
        }else if ([type isEqualToString:@"PENETRATION"]) {
            _tipsArr = @[@"奶粉",@"营养辅食",@"童车童床",@"尿裤湿巾",@"洗护用品",@"喂养用品"];
        }else if ([type isEqualToString:@"LIVING"]) {
            _tipsArr = @[@"保温壶",@"玻璃杯",@"锅具套装",@"压力锅",@"汤锅",@"水壶",@"保鲜盒",@"储物架",@"净化除味",@"烘焙/烧烤",@"刀剪菜盘",@"餐具"];
        }
        
        [self setUpViews];
    }
}

- (void)setUpViews {
    
    NSString *s = @"(最多选择3个)";
    NSString *title = [NSString stringWithFormat:@"商品标签 %@",s];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    [self.contentView addSubview:titleLabel];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr setAttributes:@{NSForegroundColorAttributeName : TCRGBColor(186, 186, 186)} range:[title rangeOfString:s]];
    titleLabel.attributedText = attStr;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(186, 186, 186);
    [self.contentView addSubview:lineView];
    
    UIView *libsView = [[UIView alloc] init];
    [self.contentView addSubview:libsView];
    self.libsView = libsView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.cornerRadius = 3.0;
    textField.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
    textField.layer.borderWidth = 0.5;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    [self.contentView addSubview:textField];
    textField.placeholder = @" 请输入商品标签，用 “、”隔开，如彩陶、玉器";
    
    UILabel *deLabel = [[UILabel alloc] init];
    deLabel.font = [UIFont systemFontOfSize:11];
    deLabel.textColor = TCRGBColor(154, 154, 154);
    deLabel.text = @"每个标签字数最多5个字，选择标签与添标签最多三个";
    [self.contentView addSubview:deLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@60);
    }];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2 : 3;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.equalTo(@(1/scale));
    }];
    
    [libsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.equalTo(@0);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(libsView.mas_bottom).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [deLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(textField);
        make.top.equalTo(textField.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    _cellHeight = 200.5;
    
    [self addLibsBtn];
    
}

- (void)addLibsBtn {
    if (_tipsArr.count > 0) {
        
        CGFloat width = TCScreenWidth - 50;
        CGFloat currentX = 0;
        CGFloat currentY = 0;
        for (int i = 0; i < _tipsArr.count; i++) {
            NSString *str = _tipsArr[i];
            
            CGFloat currentL = 0.0;
            
            if (str.length <4) {
                currentL = 49.0;
            }else if (str.length == 4) {
                currentL = 64.0;
            }else {
                currentL = 80.0;
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
            [_libsView addSubview:btn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.layer.cornerRadius = 5.0;
            btn.layer.borderColor = TCRGBColor(200, 200, 200).CGColor;
            btn.layer.borderWidth = 0.5;
            btn.clipsToBounds = YES;
            
            if (currentL > (width - currentX)) {
                currentY += 33.0;
                currentX = 0.0;
            }
            btn.frame = CGRectMake(currentX, currentY, currentL, 23);
            currentX += (currentL+15);
        }
        
        [_libsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(currentY+23));
        }];
        
        _cellHeight += (currentY+23);
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditting:)]) {
            [self.delegate textFieldShouldBeginEditting:textField];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditting:)]) {
            [self.delegate textFieldDidEndEditting:textField];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    
    if (_libsArr.count >=3 && !btn.selected) {
        [MBProgressHUD showHUDWithMessage:@"最多选择三个标签"];
        return;
    }
    
    btn.selected = !btn.selected;
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.libsArr];
    if (btn.selected) {
        [btn setBackgroundColor:[UIColor orangeColor]];
        [mutableArr addObject:btn.titleLabel.text];
    }else {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [mutableArr removeObject:btn.titleLabel.text];
    }
    self.libsArr = mutableArr;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedLib:)]) {
            [self.delegate didSelectedLib:self.libsArr];
        }
    }
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
