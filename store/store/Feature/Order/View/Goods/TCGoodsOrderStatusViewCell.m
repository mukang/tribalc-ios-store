//
//  TCGoodsOrderStatusViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderStatusViewCell.h"

@interface TCGoodsOrderStatusViewCell ()

@property (nonatomic) NSInteger totalCount;
@property (strong, nonatomic) NSMutableArray *labels;

@end

@implementation TCGoodsOrderStatusViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.totalCount = 6;
        self.labels = [NSMutableArray arrayWithCapacity:self.totalCount];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<self.totalCount; i++) {
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textColor = TCRGBColor(154, 154, 154);
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.hidden = YES;
        [self.contentView addSubview:infoLabel];
        [self.labels addObject:infoLabel];
    }
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    CGFloat topPadding = 15;
    CGFloat margin = 6;
    CGFloat labelHeight = 14;
    for (int i=0; i<self.labels.count; i++) {
        UILabel *infoLabel = self.labels[i];
        CGFloat topMargin = topPadding + (labelHeight + margin) * i;
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(topMargin);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
            make.height.mas_equalTo(labelHeight);
        }];
    }
}

- (void)setInfoArray:(NSArray *)infoArray {
    _infoArray = infoArray;
    
    for (int i=0; i<infoArray.count; i++) {
        UILabel *infoLabel = self.labels[i];
        infoLabel.hidden = NO;
        infoLabel.text = infoArray[i];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
