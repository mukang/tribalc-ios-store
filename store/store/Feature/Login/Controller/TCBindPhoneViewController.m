//
//  TCBindPhoneViewController.m
//  individual
//
//  Created by 穆康 on 2017/8/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBindPhoneViewController.h"
#import "TCStoreViewController.h"

#import "TCNumberTextField.h"

#import "TCBuluoApi.h"
#import "WXApiManager.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <WechatOpenSDK/WXApi.h>

@interface TCBindPhoneViewController ()

@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) TCNumberTextField *phoneTextField;
@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) TCNumberTextField *codeTextField;
@property (strong, nonatomic) UIButton *codeButton;
@property (strong, nonatomic) UIView *verticalLine;
@property (strong, nonatomic) UIView *firstHorizontalLine;
@property (strong, nonatomic) UIView *secondHorizontalLine;
@property (strong, nonatomic) TCCommonButton *bindButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCBindPhoneViewController {
    __weak TCBindPhoneViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"手机绑定";
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopCountDown];
}

- (void)setupSubviews {
    self.phoneLabel = [self createLabelWithText:@"手机号"];
    self.phoneTextField = [self createTextFieldWithPlaceholder:@"请输入手机号"];
    
    self.codeLabel = [self createLabelWithText:@"验证码"];
    self.codeTextField = [self createTextFieldWithPlaceholder:@"请输入验证码"];
    
    UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:TCLightGrayColor forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeButton addTarget:self action:@selector(handleClickSendCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeButton];
    self.codeButton = codeButton;
    
    self.verticalLine = [self createLineView];
    self.firstHorizontalLine = [self createLineView];
    self.secondHorizontalLine = [self createLineView];
    
    TCCommonButton *bindButton = [TCCommonButton buttonWithTitle:@"绑定手机"
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickBindButton:)];
    [self.view addSubview:bindButton];
    self.bindButton = bindButton;
}

- (void)setupConstraints {
    [self.firstHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(45);
    }];
    [self.secondHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(self.firstHorizontalLine);
        make.top.equalTo(self.firstHorizontalLine.mas_bottom).offset(45);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstHorizontalLine);
        make.centerY.equalTo(self.view.mas_top).offset(22.5);
    }];
    [self.phoneLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 21));
        make.centerY.equalTo(self.phoneLabel);
        make.right.equalTo(self.firstHorizontalLine).offset(-78);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.verticalLine.mas_right);
        make.bottom.equalTo(self.firstHorizontalLine.mas_top);
        make.right.equalTo(self.firstHorizontalLine);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.firstHorizontalLine.mas_top).offset(-5);
        make.left.equalTo(self.phoneLabel.mas_right).offset(15);
        make.right.equalTo(self.verticalLine.mas_left).offset(-5);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.phoneLabel);
        make.centerY.equalTo(self.firstHorizontalLine.mas_bottom).offset(22.5);
    }];
    [self.codeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstHorizontalLine.mas_bottom).offset(5);
        make.bottom.equalTo(self.secondHorizontalLine.mas_top).offset(-5);
        make.left.right.equalTo(self.phoneTextField);
    }];
    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.secondHorizontalLine.mas_bottom).offset(50);
    }];
}

- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = TCBlackColor;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    return label;
}

- (TCNumberTextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {
    TCNumberTextField *textField = [[TCNumberTextField alloc] init];
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                   NSForegroundColorAttributeName: TCLightGrayColor
                                                                                   }];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    
    return textField;
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self.view addSubview:lineView];
    
    return lineView;
}

#pragma mark - Actions 

- (void)handleClickSendCodeButton:(UIButton *)sender {
    [self hideKeyboard];
    
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写手机号码"];
        return;
    }
    
    [self startCountDown];
    [[TCBuluoApi api] fetchVerificationCodeWithPhone:self.phoneTextField.text result:^(BOOL success, NSError *error) {
        if (!success) {
            [weakSelf stopCountDown];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"验证码发送失败，%@", reason]];
        }
    }];
}

- (void)handleClickBindButton:(TCCommonButton *)sender {
    [self hideKeyboard];
    
    NSString *phone = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
            [weakSelf handleWechatBindWithUserID:userSession.assigned];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"绑定失败，%@", reason]];
        }
    }];
}

- (void)handleWechatBindWithUserID:(NSString *)userID {
    [[TCBuluoApi api] bindWechatByWechatCode:self.wechatCode userID:userID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf pushToStoreVC];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"绑定失败，%@", reason]];
        }
    }];
}

- (void)pushToStoreVC {
    TCStoreViewController *storeVC = [[TCStoreViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Timer

- (void)addGetSMSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetSMSTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startCountDown {
    self.timeCount = 60;
    self.codeButton.enabled = NO;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%02zds", self.timeCount] forState:UIControlStateDisabled];
    [self addGetSMSTimer];
}

- (void)stopCountDown {
    [self removeGetSMSTimer];
    self.codeButton.enabled = YES;
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        self.codeButton.enabled = YES;
        return;
    }
    [self.codeButton setTitle:[NSString stringWithFormat:@"%02zds", self.timeCount] forState:UIControlStateDisabled];
}

#pragma mark - Keyboard

- (void)hideKeyboard {
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    }
    if ([self.codeTextField isFirstResponder]) {
        [self.codeTextField resignFirstResponder];
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
