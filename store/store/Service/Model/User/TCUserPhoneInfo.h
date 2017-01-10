//
//  TCUserPhoneInfo.h
//  individual
//
//  Created by 穆康 on 2016/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUserPhoneInfo : NSObject

/** 用户手机号 */
@property (copy, nonatomic) NSString *phone;
/** 短信验证码 */
@property (copy, nonatomic) NSString *verificationCode;

@end
