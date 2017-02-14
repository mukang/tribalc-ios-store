//
//  TCWalletPasswordViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCWalletPasswordType) {
    TCWalletPasswordTypeFirstTimeInputPassword,      // 首次 - 输入密码
    TCWalletPasswordTypeFirstTimeConfirmPassword,    // 首次 - 确认密码
    TCWalletPasswordTypeResetInputOldPassword,       // 重置 - 输入旧密码
    TCWalletPasswordTypeResetInputNewPassword,       // 重置 - 输入新密码
    TCWalletPasswordTypeResetConfirmPassword,        // 重置 - 确认密码
    TCWalletPasswordTypeFindInputNewPassword,        // 找回 - 输入新密码
    TCWalletPasswordTypeFindConfirmPassword          // 找回 - 确认密码
};

extern NSString *const TCWalletPasswordKey;
extern NSString *const TCWalletPasswordDidChangeNotification;

@interface TCWalletPasswordViewController : UIViewController

@property (nonatomic, readonly) TCWalletPasswordType passwordType;
/** 旧密码 */
@property (copy, nonatomic) NSString *oldPassword;
/** 新密码 */
@property (copy, nonatomic) NSString *aNewPassword;
/** 短信验证码 */
@property (copy, nonatomic) NSString *messageCode;

/**
 指定初始化方法

 @param passwordType 密码类型
 @return 返回TCWalletPasswordViewController对象
 */
- (instancetype)initWithPasswordType:(TCWalletPasswordType)passwordType;

@end
