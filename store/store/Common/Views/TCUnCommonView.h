//
//  TCUnCommonView.h
//  store
//
//  Created by 王帅锋 on 17/2/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TCUnCommonType) {
    TCUnCommonTypeNoContent,
    TCUnCommonTypeUnCommon,
    TCUnCommonTypeUnLogin,
};

@protocol TCUnCommonViewDelegate <NSObject>

- (void)toLogin;

- (void)toAuth;

@end

@interface TCUnCommonView : UIView

@property (assign, nonatomic) TCUnCommonType unCommonType;

@property (weak, nonatomic) id<TCUnCommonViewDelegate> delegate;

@end
