//
//  TCIDCardCaptureViewController.h
//  store
//
//  Created by 穆康 on 2017/4/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCIDCardCapturePosition) {
    TCIDCardCapturePositionFront,
    TCIDCardCapturePositionBack
};

typedef void(^TCIDCardCaptureCompletion)(UIImage *image);

@interface TCIDCardCaptureViewController : TCBaseViewController

@property (nonatomic, readonly) TCIDCardCapturePosition capturePosition;
@property (copy, nonatomic) TCIDCardCaptureCompletion captureCompletion;

- (instancetype)initWithCapturePosition:(TCIDCardCapturePosition)capturePosition;

@end
