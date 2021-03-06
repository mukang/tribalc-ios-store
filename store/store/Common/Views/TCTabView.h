//
//  TCTabView.h
//  property
//
//  Created by 王帅锋 on 16/12/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnTapBlock)(NSInteger index);

@interface TCTabView : UIView

@property (copy, nonatomic) BtnTapBlock tapBlock;

@property (copy, nonatomic) NSDictionary *unreadNumDic;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;
- (void)selectIndex:(NSUInteger)index;

@end
