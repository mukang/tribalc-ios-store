//
//  TCServiceAnnotation.h
//  store
//
//  Created by 穆康 on 2017/2/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface TCServiceAnnotation : MAPointAnnotation

/** 服务ID */
@property (copy, nonatomic) NSString *serviceID;
/** 图标名字 */
@property (copy, nonatomic) NSString *imageName;

@end
