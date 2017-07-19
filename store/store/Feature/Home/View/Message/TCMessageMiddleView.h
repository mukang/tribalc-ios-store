//
//  TCMessageMiddleView.h
//  store
//
//  Created by 王帅锋 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCHomeMessage.h"

typedef NS_ENUM(NSInteger, TCMessageMiddleViewStyle) {
    TCMessageMiddleViewStyleMoneyView = 0,  //
    TCMessageMiddleViewStyleExtendCreditMiddleView,      //
    TCMessageMiddleViewStyleSubTitleMiddleView,      //
    TCMessageMiddleViewStyleOnlyMainTitle
};

@interface TCMessageMiddleView : UIView

@property (strong, nonatomic) TCHomeMessage *homeMessage;

- (instancetype)initWithFrame:(CGRect)frame style:(TCMessageMiddleViewStyle)style;

@end
