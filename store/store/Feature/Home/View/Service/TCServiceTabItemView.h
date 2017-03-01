//
//  TCServiceTabItemView.h
//  store
//
//  Created by 穆康 on 2017/2/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCServiceTabItemView : UIView

@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, getter=isSelected) BOOL selected;

@end
