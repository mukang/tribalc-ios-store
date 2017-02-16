//
//  TCImagePlayerView.h
//  individual
//
//  Created by 穆康 on 2016/12/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCImagePlayerViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end

@interface TCImagePlayerView : UIView

@property (weak, nonatomic) id<TCImagePlayerViewDelegate> delegate;

- (void)setPictures:(NSArray *)pictures isLocal:(BOOL)isLocal;

- (void)startPlaying;
- (void)stopPlaying;

- (void)hidePageControl;

- (void)prohibitPlay;

- (NSInteger)getCurrentPictureIndex;

@end
