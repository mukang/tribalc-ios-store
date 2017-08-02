//
//  TCHomeMessageOnlyMainTitleMiddleCell.m
//  individual
//
//  Created by 王帅锋 on 2017/8/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageOnlyMainTitleMiddleCell.h"
#import "TCHomeMessage.h"

@interface TCHomeMessageOnlyMainTitleMiddleCell ()

@property (strong, nonatomic) UILabel *mainTitleLabel;

@end

@implementation TCHomeMessageOnlyMainTitleMiddleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    [super setHomeMessage:homeMessage];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:homeMessage.messageBody.body];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"hi"];
    attch.bounds = CGRectMake(5, -4, 17, 17);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [att appendAttributedString:string];
    self.mainTitleLabel.attributedText = att;
}

- (void)setUpSubViews {
    
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@62);
    }];
    
    [self.middleView addSubview:self.mainTitleLabel];
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(TCRealValue(35));
        make.centerY.equalTo(self.middleView);
        make.height.equalTo(@20);
        make.right.equalTo(self.middleView).offset(-20);
    }];
}


- (UILabel *)mainTitleLabel {
    if (_mainTitleLabel == nil) {
        _mainTitleLabel = [[UILabel alloc] init];
        _mainTitleLabel.textColor = [UIColor blackColor];
        _mainTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mainTitleLabel;
}




@end
