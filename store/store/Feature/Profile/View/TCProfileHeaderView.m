//
//  TCProfileHeaderView.m
//  individual
//
//  Created by 穆康 on 2016/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileHeaderView.h"

@implementation TCProfileHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
    
    
}

- (void)setupSubviews {
    self.avatarBgView.layer.cornerRadius = 32;
    self.avatarBgView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 29.5;
    self.avatarImageView.layer.masksToBounds = YES;
    self.wantGradeButton.layer.cornerRadius = 7.5;
    self.wantGradeButton.layer.masksToBounds = YES;
    
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBio:)];
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addGestureRecognizer:tapGesture];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBio:)];
    [self.avatarBgView addGestureRecognizer:tapGesture];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBio:)];
    [self.nickBgView addGestureRecognizer:tapGesture];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    
}

#pragma mark - actions

- (IBAction)handleClickCardButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCardButtonInProfileHeaderView:)]) {
        [self.delegate didClickCardButtonInProfileHeaderView:self];
    }
}

- (IBAction)handleClickCollectButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCollectButtonInProfileHeaderView:)]) {
        [self.delegate didClickCollectButtonInProfileHeaderView:self];
    }
}

- (IBAction)handleClickGradeButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickGradeButtonInProfileHeaderView:)]) {
        [self.delegate didClickGradeButtonInProfileHeaderView:self];
    }
}

- (IBAction)handleClickPhotographButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPhotographButtonInProfileHeaderView:)]) {
        [self.delegate didClickPhotographButtonInProfileHeaderView:self];
    }
}

- (void)handleTapBio:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTapBioInProfileHeaderView:)]) {
        [self.delegate didTapBioInProfileHeaderView:self];
    }
}

@end
