//
//  TCProfileHeaderView.h
//  individual
//
//  Created by 穆康 on 2016/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCProfileHeaderView;

@protocol TCProfileHeaderViewDelegate <NSObject>

@optional
- (void)didClickCardButtonInProfileHeaderView:(TCProfileHeaderView *)view;
- (void)didClickCollectButtonInProfileHeaderView:(TCProfileHeaderView *)view;
- (void)didClickGradeButtonInProfileHeaderView:(TCProfileHeaderView *)view;
- (void)didClickPhotographButtonInProfileHeaderView:(TCProfileHeaderView *)view;
- (void)didTapBioInProfileHeaderView:(TCProfileHeaderView *)view;

@end

@interface TCProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginButton;
@property (weak, nonatomic) IBOutlet UIView *nickBgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *wantGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;

@property (weak, nonatomic) id<TCProfileHeaderViewDelegate> delegate;

@end
