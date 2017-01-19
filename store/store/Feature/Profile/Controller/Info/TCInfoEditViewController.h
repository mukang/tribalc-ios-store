//
//  TCInfoEditViewController.h
//  store
//
//  Created by 穆康 on 2017/1/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"

typedef NS_ENUM(NSInteger, TCInfoEditType) {
    TCInfoEditTypeName,
    TCInfoEditTypeLinkman
};

typedef void(^TCInfoEditBlock)();

@interface TCInfoEditViewController : TCBaseViewController

@property (nonatomic, readonly) NSInteger editType;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *linkman;
@property (copy, nonatomic) TCInfoEditBlock editBlock;

- (instancetype)initWithEditType:(TCInfoEditType)editType;

@end
