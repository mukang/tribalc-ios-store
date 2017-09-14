//
//  TCCreatePriceAndRepertoryCell.m
//  store
//
//  Created by 王帅锋 on 17/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreatePriceAndRepertoryCell.h"

@interface TCCreatePriceAndRepertoryCell ()<UITextFieldDelegate>



@end

@implementation TCCreatePriceAndRepertoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePriceOrReperoty:) name:@"KTCUPDATESTANDARDPRICEORREPEROTY" object:nil];
    }
    
    return self;
}

- (void)updatePriceOrReperoty:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *price = dict[@"price"];
        NSString *reperoty = dict[@"reperoty"];
        NSString *pfProfit = dict[@"pfProfit"];
        if ([price isKindOfClass:[NSString class]]) {
            _salePriceTextField.text = price;
        }
        
        if ([reperoty isKindOfClass:[NSString class]]) {
            _repertoryTextField.text = reperoty;
        }
        
        if ([pfProfit isKindOfClass:[NSString class]]) {
            _platformProfitTextField.text = pfProfit;
        }
    }
}

- (void)setUpViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"standardDelete"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor =TCLightGrayColor;
    [self.contentView addSubview:lineView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = TCBlackColor;
    [self.contentView addSubview:_titleLabel];
    
    _orignPriceTextField = [[UITextField alloc] init];
    _orignPriceTextField.font = [UIFont systemFontOfSize:14];
    _orignPriceTextField.layer.cornerRadius = 3.0;
    _orignPriceTextField.delegate = self;
    _orignPriceTextField.clipsToBounds = YES;
    _orignPriceTextField.placeholder = @"  输入原价";
    _orignPriceTextField.layer.borderWidth = 0.5;
    _orignPriceTextField.layer.borderColor =TCLightGrayColor.CGColor;
    _orignPriceTextField.tag = 1001;
    _orignPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_orignPriceTextField];
    
    _salePriceTextField = [[UITextField alloc] init];
    _salePriceTextField.font = [UIFont systemFontOfSize:14];
    _salePriceTextField.layer.cornerRadius = 3.0;
    _salePriceTextField.clipsToBounds = YES;
    _salePriceTextField.delegate = self;
    _salePriceTextField.placeholder = @"  输入现价";
    _salePriceTextField.layer.borderWidth = 0.5;
    _salePriceTextField.layer.borderColor =TCLightGrayColor.CGColor;
    _salePriceTextField.tag = 1002;
    _salePriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_salePriceTextField];
    
    _repertoryTextField = [[UITextField alloc] init];
    _repertoryTextField.font = [UIFont systemFontOfSize:14];
    _repertoryTextField.layer.cornerRadius = 3.0;
    _repertoryTextField.clipsToBounds = YES;
    _repertoryTextField.delegate = self;
    _repertoryTextField.placeholder = @"  输入库存";
    _repertoryTextField.layer.borderWidth = 0.5;
    _repertoryTextField.layer.borderColor =TCLightGrayColor.CGColor;
    _repertoryTextField.tag = 1003;
    _repertoryTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_repertoryTextField];
    
    _platformProfitTextField = [[UITextField alloc] init];
    _platformProfitTextField.font = [UIFont systemFontOfSize:14];
    _platformProfitTextField.layer.cornerRadius = 3.0;
    _platformProfitTextField.clipsToBounds = YES;
    _platformProfitTextField.delegate = self;
    _platformProfitTextField.placeholder = @"  平台利润";
    _platformProfitTextField.layer.borderWidth = 0.5;
    _platformProfitTextField.layer.borderColor =TCLightGrayColor.CGColor;
    _platformProfitTextField.tag = 1004;
    _platformProfitTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_platformProfitTextField];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(@28);
    }];
    CGFloat scale = [UIScreen mainScreen].bounds.size.width <= 375.0 ? 2.0 : 3.0;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deleteBtn.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(1/scale));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(lineView).offset(15);
        make.height.equalTo(@50);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    CGFloat w = (TCScreenWidth -30 - 20 * 3) / 4;
    
    [_orignPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.equalTo(@30);
        make.width.equalTo(@(w));
    }];
    
    [_salePriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orignPriceTextField.mas_right).offset(20);
        make.top.height.width.equalTo(_orignPriceTextField);
    }];
    
    [_repertoryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_salePriceTextField.mas_right).offset(20);
        make.top.height.width.equalTo(_salePriceTextField);
    }];
    
    [_platformProfitTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_repertoryTextField.mas_right).offset(20);
        make.top.height.width.equalTo(_repertoryTextField);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldShouldReturnn)]) {
            [self.delegate textFieldShouldReturnn];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger index = textField.tag;
    
    NSString *key = _titleLabel.text;
    
    NSString *subKey;
    if (index == 1001) {
        subKey = @"originPrice";
    }else if (index == 1002) {
        subKey = @"salePrice";
    }else if (index == 1003) {
        subKey = @"repertory";
    }else {
        subKey = @"pfProfit";
    }
    
    NSString *str = textField.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (str.length) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditting:)]) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:0];
                [mutableDict setObject:@{subKey:str} forKey:key];
                [self.delegate textFieldDidEndEditting:mutableDict];
            }
        }
    }
}

- (CGFloat)cellHeight {
    return 144.0;
}

- (void)delete {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(deleteCurrentStandard:)]) {
            [self.delegate deleteCurrentStandard:self];
        }
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
