//
//  TCGetPasswordView.m
//  individual
//
//  Created by 穆康 on 2016/10/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGetPasswordView.h"

@interface TCGetPasswordView ()

@property (weak, nonatomic) IBOutlet UIButton *getPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCGetPasswordView

- (void)startCountDown {
    self.timeCount = 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02zds", self.timeCount];
    self.getPasswordButton.hidden = YES;
    self.timeLabel.hidden = NO;
    [self addGetPasswordTimer];
}

- (void)stopCountDown {
    [self removeGetPasswordTimer];
    self.getPasswordButton.hidden = NO;
    self.timeLabel.hidden = YES;
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetPasswordTimer];
        self.getPasswordButton.hidden = NO;
        self.timeLabel.hidden = YES;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02zds", self.timeCount];
}

#pragma mark - timer

- (void)addGetPasswordTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetPasswordTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [self removeGetPasswordTimer];
}

#pragma mark - button actions

- (IBAction)handleTapGetPasswordButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapGetPasswordButtonInGetPasswordView:)]) {
        [self.delegate didTapGetPasswordButtonInGetPasswordView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
