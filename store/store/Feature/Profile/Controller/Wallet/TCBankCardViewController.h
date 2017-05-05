//
//  TCBankCardViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCBankCard;

typedef void(^TCBankCardSelectedCompletion)(TCBankCard *bankCard);

@interface TCBankCardViewController : TCBaseViewController

/** 是否是为了提现 */
@property (nonatomic) BOOL isForWithdraw;
@property (strong, nonatomic) NSMutableArray *dataList;

@property (copy, nonatomic) TCBankCardSelectedCompletion selectedCompletion;

@end
