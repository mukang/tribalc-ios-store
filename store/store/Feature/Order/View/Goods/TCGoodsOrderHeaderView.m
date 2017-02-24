//
//  TCGoodsOrderHeaderView.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderHeaderView.h"
#import "TCGoodsOrder.h"

@interface TCGoodsOrderHeaderView ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UILabel *orderNumLabel;
@property (weak, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation TCGoodsOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(242, 242, 242);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    
    UILabel *orderNumLabel = [[UILabel alloc] init];
    orderNumLabel.textColor = TCRGBColor(42, 42, 42);
    orderNumLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:orderNumLabel];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = TCRGBColor(81, 199, 209);
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:statusLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_order_completion"]];
    [containerView addSubview:imageView];
    
    self.containerView = containerView;
    self.orderNumLabel = orderNumLabel;
    self.statusLabel = statusLabel;
    self.imageView = imageView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(9);
        make.left.bottom.right.equalTo(weakSelf);
    }];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.containerView.mas_centerY);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf.containerView.mas_centerY);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62, 48));
        make.top.equalTo(weakSelf.containerView.mas_top);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-15);
    }];
}

- (void)setOrder:(TCGoodsOrder *)order {
    _order = order;
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", order.orderNum];
    
    if ([order.status isEqualToString:@"RECEIVED"]) {
        self.imageView.hidden = NO;
        self.statusLabel.hidden = YES;
    } else {
        self.imageView.hidden = YES;
        self.statusLabel.hidden = NO;
        if ([order.status isEqualToString:@"NO_SETTLE"]) {
            self.statusLabel.text = @"待付款";
        } else if ([order.status isEqualToString:@"SETTLE"]) {
            self.statusLabel.text = @"待发货";
        } else if ([order.status isEqualToString:@"DELIVERY"]) {
            self.statusLabel.text = @"待收货";
        } else {
            self.statusLabel.text = nil;
        }
    }
}

@end
