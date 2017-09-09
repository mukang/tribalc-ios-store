//
//  TCBioEditPhoneFailView.h
//  individual
//
//  Created by 王帅锋 on 2017/9/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCBioEditPhoneFailViewDelegate <NSObject>

- (void)didClickConfirmButton;

@end

@interface TCBioEditPhoneFailView : UIView

@property (weak, nonatomic) id<TCBioEditPhoneFailViewDelegate> delegate;

@end
