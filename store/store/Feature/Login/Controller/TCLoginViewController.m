//
//  TCLoginViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCStoreViewController.h"
#import "TCUserAgreementViewController.h"
#import "TCBindPhoneViewController.h"

#import "TCGetPasswordView.h"

#import <YYText/YYText.h>
#import <WechatOpenSDK/WXApi.h>

#import "TCBuluoApi.h"
#import "WXApiManager.h"

#import "MBProgressHUD+Category.h"

@interface TCLoginViewController () <UITextFieldDelegate, TCGetPasswordViewDelegate, WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) TCGetPasswordView *getPasswordView;
@property (nonatomic, weak) YYLabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLoginLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLabelBottomConstraint;

/** 微信唯一标示符 */
@property (copy, nonatomic) NSString *wechatState;
/** 微信code */
@property (copy, nonatomic) NSString *wechatCode;

@end

@implementation TCLoginViewController {
    __weak TCLoginViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    self.hideOriginalNavBar = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupSubviews];
    [self setupConstraints];
    
    if (![[TCBuluoApi api] needLogin]) {
        [self pushToStoreVC];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                        attributes:@{
                                                                                     NSForegroundColorAttributeName : TCRGBColor(211, 211, 211),
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                                     }];
    self.accountTextField.attributedPlaceholder = attStr;
    
    attStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                             attributes:@{
                                                          NSForegroundColorAttributeName : TCRGBColor(211, 211, 211),
                                                          NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                          }];
    self.passwordTextField.attributedPlaceholder = attStr;
    
    TCGetPasswordView *getPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"TCGetPasswordView" owner:nil options:nil] firstObject];
    getPasswordView.translatesAutoresizingMaskIntoConstraints = NO;
    getPasswordView.delegate = self;
    [self.passwordContainerView addSubview:getPasswordView];
    self.getPasswordView = getPasswordView;
    
    NSString *userAgreementStr = @"部落公社注册协议";
    NSString *noticeStr = [NSString stringWithFormat:@"注册即视为同意%@", userAgreementStr];
    NSRange highlightRange = [noticeStr rangeOfString:userAgreementStr];
    YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf handleTapUserAgreementStr];
    };
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:noticeStr];
    attText.yy_font = [UIFont systemFontOfSize:12];
    attText.yy_color = TCRGBColor(211, 211, 211);
    [attText yy_setColor:TCRGBColor(38, 38, 38) range:highlightRange];
    [attText yy_setTextHighlight:highlight range:highlightRange];
    
    YYLabel *noticeLabel = [[YYLabel alloc] init];
    noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noticeLabel.attributedText = attText;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.size = CGSizeMake(350, 20);
    noticeLabel.x = 50;
    noticeLabel.y = 200;
    [self.view addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
}

- (void)setupConstraints {
    // constraint
    self.accountViewTopConstraint.constant = TCRealValue(305);
    self.wechatButtonBottomConstraint.constant = TCRealValue(63.5);
    self.otherLabelBottomConstraint.constant = TCRealValue(42);
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1.0
                                                                   constant:71];
    [self.getPasswordView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:0
                                             multiplier:1.0
                                               constant:23];
    [self.getPasswordView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordContainerView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.passwordContainerView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordContainerView
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:-8];
    [self.passwordContainerView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.loginButton
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:9];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:0
                                             multiplier:1.0
                                               constant:14];
    [self.noticeLabel addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:17];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:-17];
    [self.view addConstraint:constraint];
    
}

#pragma mark - Actions

- (IBAction)handleTapBackButton:(UIButton *)sender {
    [self hideKeyboard];
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)handleTapLoginButton:(UIButton *)sender {
    [self hideKeyboard];
    
    NSString *phone = [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phone.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写手机号码"];
        return;
    }
    if (password.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写验证码"];
    }
    
    TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
    phoneInfo.phone = phone;
    phoneInfo.verificationCode = password;
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] login:phoneInfo result:^(TCUserSession *userSession, NSError *error) {
        if (userSession) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf == [weakSelf.navigationController topViewController]) {
                [weakSelf pushToStoreVC];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"登录失败，%@", reason]];
        }
    }];
}

- (void)pushToStoreVC {
    TCStoreViewController *storeVC = [[TCStoreViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (IBAction)handleTapWechatButton:(UIButton *)sender {
    [WXApiManager sharedManager].delegate = self;
    self.wechatState = [NSString stringWithFormat:@"buluo-gs-%d", arc4random()];
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = self.wechatState;
    [WXApi sendReq:req];
}

- (void)handleWechatLogin {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] loginByWechatCode:self.wechatCode result:^(BOOL isBind, TCUserSession *userSession, NSError *error) {
        if (error) {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"登录失败，%@", reason]];
        } else {
            [MBProgressHUD hideHUD:YES];
            if (isBind) {
                if (weakSelf == [weakSelf.navigationController topViewController]) {
                    [weakSelf pushToStoreVC];
                }
            } else {
                [weakSelf handleShowBindPhoneViewController];
            }
        }
    }];
}

- (void)handleShowBindPhoneViewController {
    TCBindPhoneViewController *vc = [[TCBindPhoneViewController alloc] init];
    vc.wechatCode = self.wechatCode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleTapViewGesture:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

- (void)handleTapUserAgreementStr {
    TCUserAgreementViewController *vc = [[TCUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCGetPasswordViewDelegate

- (void)didTapGetPasswordButtonInGetPasswordView:(TCGetPasswordView *)view {
    [self hideKeyboard];
    
    if (self.accountTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写手机号码"];
        return;
    }
    
    [self.getPasswordView startCountDown];
    [[TCBuluoApi api] fetchVerificationCodeWithPhone:self.accountTextField.text result:^(BOOL success, NSError *error) {
        if (!success) {
            [weakSelf.getPasswordView stopCountDown];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"验证码发送失败，%@", reason]];
        }
    }];
}

#pragma mark - Keyboard

- (void)hideKeyboard {
    if ([self.accountTextField isFirstResponder]) {
        [self.accountTextField resignFirstResponder];
    }
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
