//
//  TCGoodsOrderNoteViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderNoteViewCell.h"

@interface TCGoodsOrderNoteViewCell ()

@property (weak, nonatomic) UIView *containerView;

@end

@implementation TCGoodsOrderNoteViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = TCBackgroundColor;
    [self.contentView addSubview:containerView];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = TCGrayColor;
    noteLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:noteLabel];
    
    self.containerView = containerView;
    self.noteLabel = noteLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(5);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.height.mas_equalTo(31);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(8);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-8);
        make.top.bottom.equalTo(weakSelf.containerView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
