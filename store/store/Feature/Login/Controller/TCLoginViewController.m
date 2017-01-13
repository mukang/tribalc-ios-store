//
//  TCLoginViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCUserAgreementViewController.h"

#import "TCGetPasswordView.h"

#import <YYText/YYText.h>

#import "TCBuluoApi.h"

#import "MBProgressHUD+Category.h"

@interface TCLoginViewController () <UITextFieldDelegate, TCGetPasswordViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) TCGetPasswordView *getPasswordView;
@property (nonatomic, weak) YYLabel *noticeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alipayButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLabelBottomConstraint;

@end

@implementation TCLoginViewController {
    __weak TCLoginViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

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
    self.alipayButtonBottomConstraint.constant = TCRealValue(63.5);
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


#pragma mark - button action

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
            [weakSelf handleTapBackButton:nil];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"登录失败，%@", reason]];
        }
    }];
}

- (IBAction)handleTapAlipayButton:(UIButton *)sender {
    NSLog(@"支付宝登录");
}

- (IBAction)handleTapWechatButton:(UIButton *)sender {
    NSLog(@"微信登录");
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
