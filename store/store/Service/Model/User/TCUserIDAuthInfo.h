//
//  TCUserIDAuthInfo.h
//  individual
//
//  Created by 穆康 on 2016/12/20.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用户身份认证信息
 */
@interface TCUserIDAuthInfo : NSObject

/** 姓名 */
@property (copy, nonatomic) NSString *name;
/** 性别（UNKNOWN, MALE, FEMALE） */
@property (copy, nonatomic) NSString *personSex;
/** 出生日期 */
@property (nonatomic) int64_t birthday;
/** 身份证号 */
@property (copy, nonatomic) NSString *idNo;


@end
