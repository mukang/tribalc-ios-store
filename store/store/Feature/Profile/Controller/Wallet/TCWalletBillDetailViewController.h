//
//  TCWalletBillDetailViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCWalletBill;
@class TCWithDrawRequest;

@interface TCWalletBillDetailViewController : UIViewController

@property (strong, nonatomic) TCWalletBill *walletBill;

@property (strong, nonatomic) TCWithDrawRequest *withDrawRequest;

@end
