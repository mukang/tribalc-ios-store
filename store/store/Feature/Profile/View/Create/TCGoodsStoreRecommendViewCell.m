//
//  TCGoodsStoreRecommendViewCell.m
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStoreRecommendViewCell.h"
#import "TCCreateStorePromptView.h"

@implementation TCGoodsStoreRecommendViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupPromptView];
    }
    return self;
}

- (void)setupPromptView {
    TCCreateStorePromptView *promptView = [[TCCreateStorePromptView alloc] init];
    [self.contentView addSubview:promptView];
    
    __weak typeof(self) weakSelf = self;
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(154);
        make.left.bottom.right.equalTo(weakSelf.contentView);
    }];
}

@end
