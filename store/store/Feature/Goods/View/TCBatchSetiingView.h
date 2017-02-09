//
//  TCBatchSetiingView.h
//  store
//
//  Created by 王帅锋 on 17/1/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)();

@interface TCBatchSetiingView : UIView

@property (copy,nonatomic) DeleteBlock deleteBlock;

@end
