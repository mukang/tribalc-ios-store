//
//  TCStoreRecommendViewCell.h
//  store
//
//  Created by 穆康 on 2017/1/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYTextView.h>

@interface TCStoreRecommendViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) YYTextView *textView;

@end
