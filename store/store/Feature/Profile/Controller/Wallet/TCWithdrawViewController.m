//
//  TCWithdrawViewController.m
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithdrawViewController.h"

#import "TCWithdrawBankCardInfoView.h"
#import "TCWithdrawAmountView.h"
#import "TCPaymentPasswordView.h"

#import "TCBankCardViewController.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCFunctions.h>

#define passwordViewH 400
#define duration 0.25

@interface TCWithdrawViewController () <UITextFieldDelegate, TCPaymentPasswordViewDelegate, TCWithdrawAmountViewDelegate>

@property (copy, nonatomic) NSArray *bankInfoList;
@property (strong, nonatomic) TCBankCard *currentBankCard;
/** 可转出金额 */
@property (nonatomic) double enabledAmount;

@property (weak, nonatomic) TCWithdrawBankCardInfoView *bankCardInfoView;
@property (weak, nonatomic) TCWithdrawAmountView *amountView;
@property (weak, nonatomic) TCCommonButton *withdrawButton;

/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;

/** 密码输入页面的背景 */
@property (weak, nonatomic) UIView *bgView;
/** 密码输入页面 */
@property (weak, nonatomic) TCPaymentPasswordView *passwordView;

@end

@implementation TCWithdrawViewController {
    __weak TCWithdrawViewController *weakSelf;
}

- (instancetype)initWithWalletAccount:(TCWalletAccount *)walletAccount {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _walletAccount = walletAccount;
        _enabledAmount = walletAccount.balance - walletAccount.withdrawCharge;
        if (_enabledAmount < 0.0) {
            _enabledAmount = 0.0;
        }
        [self updateBankCardList];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提现";
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)updateBankCardList {
    for (TCBankCard *bankCard in self.walletAccount.bankCards) {
        for (NSDictionary *bankInfo in self.bankInfoList) {
            if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                bankCard.logo = bankInfo[@"logo"];
                bankCard.bgImage = bankInfo[@"bgImage"];
                break;
            }
        }
    }
    self.currentBankCard = self.walletAccount.bankCards[0];
}

- (void)setupSubviews {
    self.view.backgroundColor = TCBackgroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [self.view addGestureRecognizer:tap];
    
    TCWithdrawBankCardInfoView *bankCardInfoView = [[TCWithdrawBankCardInfoView alloc] init];
    bankCardInfoView.bankCard = self.currentBankCard;
    [self.view addSubview:bankCardInfoView];
    UITapGestureRecognizer *bankCardInfoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBankCardInfoView:)];
    [bankCardInfoView addGestureRecognizer:bankCardInfoViewTap];
    
    TCWithdrawAmountView *amountView = [[TCWithdrawAmountView alloc] init];
    amountView.walletAccount = self.walletAccount;
    amountView.enabledAmount = self.enabledAmount;
    amountView.amountTextField.delegate = self;
    amountView.delegate = self;
    [self.view addSubview:amountView];
    
    TCCommonButton *withdrawButton = [TCCommonButton buttonWithTitle:@"确认提现"
                                                               color:TCCommonButtonColorBlue
                                                              target:self
                                                              action:@selector(handleClickWithdrawButton:)];
    UIImage *disabledImage = [UIImage imageWithColor:TCRGBColor(218, 216, 217)];
    [withdrawButton setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    withdrawButton.enabled = NO;
    [self.view addSubview:withdrawButton];
    
    
    self.bankCardInfoView = bankCardInfoView;
    self.amountView = amountView;
    self.withdrawButton = withdrawButton;
}

- (void)setupConstraints {
    [self.bankCardInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(9);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(61);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bankCardInfoView.mas_bottom).offset(14);
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.amountView.mas_bottom).offset(53);
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /*
     * 不能输入.0-9以外的字符
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.havePoint = YES;
    } else {
        self.havePoint = NO;
    }
    
    if (string.length > 0) {
        // 当前输入的字符
        unichar character = [string characterAtIndex:0];
        TCLog(@"single = %c",character);
        
        // 不能输入.0-9以外的字符
        if (((character < '0') || (character > '9')) && (character != '.')) {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHavePoint && character == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0
        if (textField.text.length == 0 && character == '.') {
            textField.text = @"0";
        }
        // 如果第一位是0则后面必须输入点，否则不能输入
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
        
                NSString *secondCharacter = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondCharacter isEqualToString:@"."]) {
                    return NO;
                }
            } else {
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHavePoint) {
            NSRange pointRange = [textField.text rangeOfString:@"."];
            if (range.location > pointRange.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - TCWithdrawAmountViewDelegate

- (void)didClickAllWithdrawButtonInWithdrawAmountView:(TCWithdrawAmountView *)view {
    [self dismissKeyboard];
    
    self.amountView.amountTextField.text = [NSString stringWithFormat:@"%0.2f", self.enabledAmount];
    if (self.enabledAmount > 0.0) {
        if (!self.withdrawButton.enabled) {
            self.withdrawButton.enabled = YES;
        }
    } else {
        if (self.withdrawButton.enabled) {
            self.withdrawButton.enabled = NO;
        }
    }
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self handleCommitWithdrawWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPasswordView];
}

#pragma mark - Actions

- (void)handleClickWithdrawButton:(UIButton *)sender {
    [self dismissKeyboard];
    
    NSString *text = self.amountView.amountTextField.text;
    if ([text doubleValue] > self.enabledAmount) {
        [MBProgressHUD showHUDWithMessage:@"提现金额已超出可转出金额，请重新输入"];
        return;
    }
    [self showPasswordView];
}

- (void)handleCommitWithdrawWithPassword:(NSString *)password {
    if (![self.walletAccount.password isEqualToString:TCDigestMD5(password)]) {
        [MBProgressHUD showHUDWithMessage:@"密码错误，请重新输入"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [self.passwordView.textField resignFirstResponder];
    [self dismissPasswordView];
    double amount = [self.amountView.amountTextField.text doubleValue];
    [[TCBuluoApi api] commitWithdrawReqWithAmount:amount bankCardID:self.currentBankCard.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"申请提现成功，资金将在48小时内到账，请注意查收"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf handleClickBackButton:nil];
                if (weakSelf.completionBlock) {
                    weakSelf.completionBlock();
                }
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"提现失败，%@", reason]];
        }
    }];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    NSString *text = self.amountView.amountTextField.text;
    if ((text.length > 0) && ([text doubleValue] != 0)) {
        if (self.withdrawButton.enabled == NO) {
            self.withdrawButton.enabled = YES;
        }
    } else {
        if (self.withdrawButton.enabled == YES) {
            self.withdrawButton.enabled = NO;
        }
    }
}

- (void)handleTapBankCardInfoView:(UITapGestureRecognizer *)sender {
    TCBankCardViewController *vc = [[TCBankCardViewController alloc] initWithNibName:@"TCBankCardViewController" bundle:[NSBundle mainBundle]];
    vc.isForWithdraw = YES;
    vc.walletAccount = self.walletAccount;
    vc.selectedCompletion = ^(TCBankCard *bankCard) {
        weakSelf.currentBankCard = bankCard;
        weakSelf.bankCardInfoView.bankCard = bankCard;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleTapView:(UITapGestureRecognizer *)sender {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    if ([self.amountView.amountTextField isFirstResponder]) {
        [self.amountView.amountTextField resignFirstResponder];
    }
}

#pragma mark - Password View

- (void)showPasswordView {
    UIView *superView = self.tabBarController.view;
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [superView addSubview:bgView];
    [superView bringSubviewToFront:bgView];
    self.bgView = bgView;
    
    TCPaymentPasswordView *passwordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    passwordView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, passwordViewH);
    passwordView.delegate = self;
    [bgView addSubview:passwordView];
    self.passwordView = passwordView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        passwordView.y = TCScreenHeight - passwordViewH;
    } completion:^(BOOL finished) {
        [passwordView.textField becomeFirstResponder];
    }];
}

- (void)dismissPasswordView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.passwordView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf.passwordView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
    }];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override Methods

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
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
