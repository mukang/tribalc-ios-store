//
//  TCNumberTextField.m
//  individual
//
//  Created by 穆康 on 2017/6/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCNumberTextField.h"

@implementation TCNumberTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 44)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickDoneItem:)];
    [doneItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}
                            forState:UIControlStateNormal];
    toolBar.items = @[spaceItem, doneItem];
    self.inputAccessoryView = toolBar;
    self.toolBar = toolBar;
}

- (void)handleClickDoneItem:(id)sender {
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
    if ([self.numDelegate respondsToSelector:@selector(didClickDoneItemInNumberTextField:)]) {
        [self.numDelegate didClickDoneItemInNumberTextField:self];
    }
}

@end
