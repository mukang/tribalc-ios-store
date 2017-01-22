//
//  TCCreateStorePromptView.m
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreateStorePromptView.h"

@implementation TCCreateStorePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"入住过程中如有问题请拨打";
    promptLabel.textColor = TCRGBColor(154, 154, 154);
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:promptLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"4009-208-251";
    phoneLabel.textColor = TCRGBColor(252, 108, 38);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:phoneLabel];
    
    __weak typeof(self) weakSelf = self;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(10);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_top);
        make.left.equalTo(promptLabel.mas_right).with.offset(2);
    }];
}

@end
