//
//  TCGoodsPriceAndRepertory.m
//  store
//
//  Created by 王帅锋 on 17/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsPriceAndRepertory.h"

@implementation TCGoodsPriceAndRepertory

- (void)setPfProfit:(double)pfProfit {
    _pfProfit = pfProfit;
    _realPfProfit = pfProfit;
    _realSalePrice = _salePrice-pfProfit;
}

- (void)setSalePrice:(double)salePrice {
    _salePrice = salePrice;
    _realSalePrice = salePrice-_pfProfit;
}

- (void)setRealSalePrice:(double)realSalePrice {
    _realSalePrice = realSalePrice;
    _salePrice = realSalePrice+_pfProfit;
}

- (void)setRealPfProfit:(double)realPfProfit {
    _realPfProfit = realPfProfit;
    _pfProfit = realPfProfit;
    _salePrice = _realSalePrice+realPfProfit;
}

@end
