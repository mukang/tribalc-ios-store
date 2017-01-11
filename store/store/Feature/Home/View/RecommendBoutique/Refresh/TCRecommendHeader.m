//
//  TCRecommendHeader.m
//  individual
//
//  Created by WYH on 16/11/17.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendHeader.h"

@implementation TCRecommendHeader {
    
}

- (void)prepare {
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    
    [self setTitle:@"刷新完毕" forState:MJRefreshStateIdle];
    [self setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"松手即刷新" forState:MJRefreshStatePulling];
    
}

- (void)placeSubviews {
    [super placeSubviews];
    
}

@end
