//
//  TCServiceListCell.h
//  store
//
//  Created by 王帅锋 on 17/2/16.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCService;
@interface TCServiceListCell : UITableViewCell

@property (strong, nonatomic) TCService *service;

@property (assign, nonatomic) BOOL isRes;

@end
