//
//  TCWalletPasswordViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletPasswordViewController.h"
#import "TCBioEditSMSViewController.h"

#import "MLBPasswordTextField.h"
#import "TCCommonButton.h"
#import "TCExtendButton.h"

#import "TCFunctions.h"
#import "TCBuluoApi.h"
#import "UIImage+Category.h"
#import <Masonry.h>

NSString *const TCWalletPasswordKey = @"TCWalletPasswordKey";
NSString *const TCWalletPasswordDidChangeNotification = @"TCWalletPasswordDidChangeNotification";

@interface TCWalletPasswordViewController () <MLBPasswordTextFieldDelegate>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) MLBPasswordTextField *passwordTextField;
@property (weak, nonatomic) TCCommonButton *nextButton;
@property (weak, nonatomic) TCExtendButton *forgetButton;

@property (copy, nonatomic) NSString *password;
@property (nonatomic) NSInteger passwordLength;

@end

@implementation TCWalletPasswordViewController {
    __weak TCWalletPasswordViewController *weakSelf;
}

- (instancetype)initWithPasswordType:(TCWalletPasswordType)passwordType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _passwordType = passwordType;
        _passwordLength = 6;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.passwordTextField isFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    NSString *titleLabelText;
    NSString *navBarTitle;
    switch (self.passwordType) {
        case TCWalletPasswordTypeFirstTimeInputPassword:
            titleLabelText = @"输入支付密码";
            navBarTitle = @"支付密码";
            break;
        case TCWalletPasswordTypeFirstTimeConfirmPassword:
            titleLabelText = @"确认支付密码";
            navBarTitle = @"支付密码";
            break;
        case TCWalletPasswordTypeResetInputOldPassword:
            titleLabelText = @"输入支付密码，完成身份验证";
            navBarTitle = @"重置支付密码";
            break;
        case TCWalletPasswordTypeResetInputNewPassword:
            titleLabelText = @"输入新支付密码";
            navBarTitle = @"重置支付密码";
            break;
        case TCWalletPasswordTypeResetConfirmPassword:
            titleLabelText = @"确认支付密码";
            navBarTitle = @"重置支付密码";
            break;
        case TCWalletPasswordTypeFindInputNewPassword:
            titleLabelText = @"输入新支付密码";
            navBarTitle = @"重置支付密码";
            break;
        case TCWalletPasswordTypeFindConfirmPassword:
            titleLabelText = @"确认支付密码";
            navBarTitle = @"重置支付密码";
            break;
            
        default:
            break;
    }
    
    self.navigationItem.title = navBarTitle;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleLabelText;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    MLBPasswordTextField *textField = [[MLBPasswordTextField alloc] init];
    textField.mlb_numberOfDigit = 6;
    textField.mlb_borderColor = TCSeparatorLineColor;
    textField.mlb_borderWidth = 0.5;
    textField.mlb_dotColor = TCBlackColor;
    textField.mlb_dotRadius = 3.5;
    textField.mlb_delegate = self;
    [self.view addSubview:textField];
    self.passwordTextField = textField;
    
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:@"下一步" target:self action:@selector(handleClickNextButton:)];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    TCExtendButton *forgetButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *normalAttStr = [[NSAttributedString alloc] initWithString:@"忘记原密码"
                                                                       attributes:@{
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                    NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                                                    }];
    NSAttributedString *highlightedAttStr = [[NSAttributedString alloc] initWithString:@"忘记原密码"
                                                                            attributes:@{
                                                                                         NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                         NSForegroundColorAttributeName: TCRGBColor(10, 164, 177)
                                                                                         }];
    [forgetButton setAttributedTitle:normalAttStr forState:UIControlStateNormal];
    [forgetButton setAttributedTitle:highlightedAttStr forState:UIControlStateHighlighted];
    [forgetButton addTarget:self action:@selector(handleClickForgetButton:) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.view addSubview:forgetButton];
    self.forgetButton = forgetButton;
    if (self.passwordType == TCWalletPasswordTypeResetInputOldPassword) {
        forgetButton.hidden = NO;
    } else {
        forgetButton.hidden = YES;
    }
}

- (void)setupConstraints {
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(55);
        make.size.mas_equalTo(CGSizeMake(TCRealValue(337), TCRealValue(50)));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(22);
        make.left.right.equalTo(weakSelf.passwordTextField);
    }];
    
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordTextField.mas_bottom).with.offset(8);
        make.right.equalTo(weakSelf.passwordTextField.mas_right);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordTextField.mas_bottom).with.offset(36.5);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//#pragma mark - MLBPasswordTextFieldDelegate
//
//- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
//    self.password = password;
//}

#pragma mark - Actions

- (void)handleClickNextButton:(UIButton *)sender {
    self.password = self.passwordTextField.text;
    
    switch (self.passwordType) {
        case TCWalletPasswordTypeFirstTimeInputPassword:
            [self handleFirstTimeInputPassword];
            break;
        case TCWalletPasswordTypeFirstTimeConfirmPassword:
            [self handleFirstTimeConfirmPassword];
            break;
        case TCWalletPasswordTypeResetInputOldPassword:
            [self handleResetInputOldPassword];
            break;
        case TCWalletPasswordTypeResetInputNewPassword:
            [self handleResetInputNewPassword];
            break;
        case TCWalletPasswordTypeResetConfirmPassword:
            [self handleResetConfirmPassword];
            break;
        case TCWalletPasswordTypeFindInputNewPassword:
            [self handleFindInputNewPassword];
            break;
        case TCWalletPasswordTypeFindConfirmPassword:
            [self handleFindConfirmPassword];
            break;
            
        default:
            break;
    }
}

- (void)handleClickForgetButton:(UIButton *)sender {
    TCBioEditSMSViewController *vc = [[TCBioEditSMSViewController alloc] initWithMessageCodeType:TCMessageCodeTypeFindPassword];
    vc.phone = [[TCBuluoApi api] currentUserSession].storeInfo.phone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleFirstTimeInputPassword {
    if (self.password.length != self.passwordLength) {
        [MBProgressHUD showHUDWithMessage:@"请输入支付密码！"];
        return;
    }
    
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeFirstTimeConfirmPassword];
    vc.aNewPassword = self.password;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleFirstTimeConfirmPassword {
    [self handleSetPassword];
}

- (void)handleResetInputOldPassword {
    if (self.password.length != self.passwordLength) {
        [MBProgressHUD showHUDWithMessage:@"请输入支付密码！"];
        return;
    }
    
    NSString *digestStr = TCDigestMD5(self.password);
    if ([digestStr isEqualToString:self.oldPassword]) {
        TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeResetInputNewPassword];
        vc.oldPassword = self.password;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUD showHUDWithMessage:@"密码错误，请重新输入"];
    }
}

- (void)handleResetInputNewPassword {
    if (self.password.length != self.passwordLength) {
        [MBProgressHUD showHUDWithMessage:@"请输入新支付密码！"];
        return;
    }
    
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeResetConfirmPassword];
    vc.aNewPassword = self.password;
    vc.oldPassword = self.oldPassword;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleResetConfirmPassword {
    [self handleSetPassword];
}

- (void)handleFindInputNewPassword {
    if (self.password.length != self.passwordLength) {
        [MBProgressHUD showHUDWithMessage:@"请输入新支付密码！"];
        return;
    }
    
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeFindConfirmPassword];
    vc.aNewPassword = self.password;
    vc.messageCode = self.messageCode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleFindConfirmPassword {
    [self handleSetPassword];
}

- (void)handleSetPassword {
    if (![self.aNewPassword isEqualToString:self.password]) {
        [MBProgressHUD showHUDWithMessage:@"输入的密码不一致，请重新输入"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeWalletPassword:self.messageCode anOldPassword:self.oldPassword aNewPassword:self.aNewPassword result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"设置成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCWalletPasswordDidChangeNotification object:nil userInfo:@{TCWalletPasswordKey: TCDigestMD5(weakSelf.aNewPassword)}];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = weakSelf.navigationController.childViewControllers[1];
                [weakSelf.navigationController popToViewController:vc animated:YES];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"设置失败，%@", reason]];
        }
    }];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
