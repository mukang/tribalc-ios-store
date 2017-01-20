//
//  TCInfoEditViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCInfoEditViewCell.h"

@implementation TCInfoEditViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = TCRGBColor(42, 42, 42);
    textField.font = [UIFont systemFontOfSize:14];
    textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.top.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(100);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(120);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                           attributes:@{
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                        NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                                        }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
