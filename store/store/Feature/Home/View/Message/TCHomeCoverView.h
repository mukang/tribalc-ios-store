//
//  TCHomeCoverView.h
//  store
//
//  Created by 王帅锋 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCHomeMessage;
@class TCHomeMessageCell;

@protocol TCHomeCoverViewDelegate <NSObject>

- (void)didClickOverLookMessage:(TCHomeMessage *)message currentCell:(TCHomeMessageCell *)cell;

- (void)didClickNeverShowMessage:(TCHomeMessage *)message;

@end

@interface TCHomeCoverView : UIView

@property (assign, nonatomic) CGRect rect;

@property (strong, nonatomic) TCHomeMessage *homeMessage;

@property (weak, nonatomic) TCHomeMessageCell *currentCell;

@property (weak, nonatomic) id <TCHomeCoverViewDelegate>delegate;

@end
