//
//  TCServiceAnnotationView.h
//  store
//
//  Created by 穆康 on 2017/2/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@protocol TCServiceAnnotationViewDelegate;

@interface TCServiceAnnotationView : MAAnnotationView

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) id<TCServiceAnnotationViewDelegate> delegate;

@end


@protocol TCServiceAnnotationViewDelegate <NSObject>

@optional
- (void)didClickInfoButtonInServiceAnnotationView:(TCServiceAnnotationView *)view;

@end
