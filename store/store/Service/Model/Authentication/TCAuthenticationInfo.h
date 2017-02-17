//
//  TCAuthenticationInfo.h
//  store
//
//  Created by 王帅锋 on 17/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAuthenticationInfo : NSObject

@property (copy, nonatomic) NSArray *idCardPicture;

@property (copy, nonatomic) NSString *businessLicense;

@property (copy, nonatomic) NSString *tradeLicense;

@property (copy, nonatomic) NSString *authenticationStatus;

@end
