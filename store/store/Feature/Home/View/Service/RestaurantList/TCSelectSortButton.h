//
//  TCSelectSortButton.h
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCSelectSortButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndText:(NSString *)text;

@property (nonatomic, assign) BOOL isSelected;

@end
