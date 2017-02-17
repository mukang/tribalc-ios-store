//
//  TCSetMainGoodView.h
//  store
//
//  Created by 王帅锋 on 17/2/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)();

typedef void(^CertainBlock)(NSString *);

@interface TCSetMainGoodView : UIView

@property (copy, nonatomic) NSArray *standards;

@property (copy, nonatomic) DeleteBlock deletaBlock;

@property (copy, nonatomic) CertainBlock certainBlock;

@end
