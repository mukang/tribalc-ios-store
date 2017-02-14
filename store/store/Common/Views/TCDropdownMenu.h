//
//  TCDropdownMenu.h
//  store
//
//  Created by 穆康 on 2017/2/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCDropdownMenuDelegate;

@interface TCDropdownMenu : UIView

@property (nonatomic) BOOL menuIsShow;
@property (weak, nonatomic) id<TCDropdownMenuDelegate> delegate;

- (void)setMenuTitles:(NSArray *)titles rowHeight:(CGFloat)rowHeight;

- (void)showDropDown; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单

@end

@protocol TCDropdownMenuDelegate <NSObject>

@optional

- (void)dropdownMenuWillShow:(TCDropdownMenu *)dropdownMenu;
- (void)dropdownMenu:(TCDropdownMenu *)dropdownMenu didSelectName:(NSString *)name;

@end
