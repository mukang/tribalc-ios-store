//
//  TCRecommendSelectView.h
//  individual
//
//  Created by WYH on 16/12/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCModelImport.h"

@class TCGoodSelectView;

@protocol TCGoodSelectViewDelegate <NSObject>

@optional
- (void)selectView:(TCGoodSelectView *)goodSelectView didAddShoppingCartWithGoodDetail:(TCGoodDetail *)goodDetail Amount:(NSInteger)amount;

- (void)selectView:(TCGoodSelectView *)goodSelectView didChangeStandardButtonWithGoodDetail:(TCGoodDetail *)goodDetail;

@end



@interface TCGoodSelectView : UIView

@property (nonatomic, weak) id<TCGoodSelectViewDelegate> delegate;

@property (nonatomic) TCGoodStandards *goodStandard;

- (instancetype)initWithGoodDetail:(TCGoodDetail *)good;

- (void)show;


- (void)setupGoodStandard:(TCGoodStandards *)goodStandards;

@end
