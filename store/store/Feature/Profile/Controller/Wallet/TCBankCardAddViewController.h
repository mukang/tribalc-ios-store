//
//  TCBankCardAddViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TCBankCardAddBlock)();

@interface TCBankCardAddViewController : UIViewController

@property (copy, nonatomic) TCBankCardAddBlock bankCardAddBlock;

@end
