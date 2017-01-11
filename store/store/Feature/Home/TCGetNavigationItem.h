//
//  TCGetNavigationItem.h
//  individual
//
//  Created by WYH on 16/11/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGetNavigationItem : NSObject

+ (UIBarButtonItem *)getBarItemWithFrame:(CGRect)frame AndImageName:(NSString *)imgName;

+ (UILabel *)getTitleItemWithText:(NSString *)text;

+ (UIButton *)getBarButtonWithFrame:(CGRect)frame AndImageName:(NSString *)imageName;
@end
