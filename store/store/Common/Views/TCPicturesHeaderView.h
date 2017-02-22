//
//  TCPicturesHeaderView.h
//  individual
//
//  Created by 穆康 on 2017/2/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCPicturesHeaderViewDelegate;

/**
 头部图片视图，支持多张和下拉放大
 */
@interface TCPicturesHeaderView : UIView

@property (strong, nonatomic) NSArray *pictures;
@property (weak, nonatomic) id<TCPicturesHeaderViewDelegate> delegate;

@end

@protocol TCPicturesHeaderViewDelegate <NSObject>

@optional
- (void)picturesHeaderView:(TCPicturesHeaderView *)view didScrollToIndex:(NSInteger)index;

@end
