//
//  TCStoreFeature.h
//  store
//
//  Created by 穆康 on 2017/1/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCStoreFeature : NSObject

/** 特色 */
@property (copy, nonatomic) NSString *name;
/** 是否被选中 */
@property (nonatomic, getter=isSelected) BOOL selected;

@end
