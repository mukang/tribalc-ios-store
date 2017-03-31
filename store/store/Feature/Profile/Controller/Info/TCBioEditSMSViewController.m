//
//  TCBioEditSMSViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditSMSViewController.h"
#import "TCInfoViewController.h"
//#import "TCWalletPasswordViewController.h"

#import <TCCommonLibs/UIImage+Category.h>

#import "TCBuluoApi.h"

@interface TCBioEditSMSViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCBioEditSMSViewController {
    __weak TCBioEditSMSViewController *weakSelf;
}

- (instancetype)initWithMessageCodeType:(TCMessageCodeType)messageCodeType {
    self = [super initWithNibName:@"TCBioEditSMSViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        weakSelf = self;
        _messageCodeType = messageCodeType;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.noticeLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信校验码", self.phone];
    [self setupNavBar];
    [self setupSubviews];
    [self handleClickResendButton:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)dealloc {
    [self removeGetSMSTimer];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    NSString *buttonTitle;
    NSString *navBarTitle;
    if (self.messageCodeType == TCMessageCodeTypeFindPassword) {
        buttonTitle = @"下一步";
        navBarTitle = @"安全校验";
    } else {
        buttonTitle = @"提交";
        navBarTitle = @"手机绑定";
    }
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:buttonTitle
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                              NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                              }];
    [self.commitButton setAttributedTitle:attStr forState:UIControlStateNormal];
    UIImage *normalImage = [UIImage imageWithColor:TCRGBColor(81, 199, 209)];
    UIImage *highlightedImage = [UIImage imageWithColor:TCRGBColor(10, 164, 177)];
    [self.commitButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    self.commitButton.layer.cornerRadius = 2.5;
    self.commitButton.layer.masksToBounds = YES;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)handleClickResendButton:(UIButton *)sender {
    [self startCountDown];
    
    [[TCBuluoApi api] fetchVerificationCodeWithPhone:self.phone result:^(BOOL success, NSError *error) {
        if (!success) {
            NSString *reason = error.localizedDescription ?: @"请重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"验证码发送失败，%@", reason]];
            [weakSelf stopCountDown];
        }
    }];
}

- (IBAction)handleClickCommitButton:(UIButton *)sender {
    NSString *code = self.textField.text;
    if (code.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入验证码"];
        return;
    }
    
    if (self.messageCodeType == TCMessageCodeTypeFindPassword) {
//        TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeFindInputNewPassword];
//        vc.messageCode = code;
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self handleChangeUserPhoneWithCode:code];
    }
}

- (void)handleChangeUserPhoneWithCode:(NSString *)code {
    TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
    phoneInfo.phone = self.phone;
    phoneInfo.verificationCode = code;
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changePhone:phoneInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (self.editPhoneBlock) {
                self.editPhoneBlock(YES);
            }
            TCInfoViewController *vc = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:vc animated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"手机号修改失败，%@", reason]];
        }
    }];
}

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    TCInfoViewController *vc = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)handleTapView:(UITapGestureRecognizer *)sender {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - Count Down

- (void)startCountDown {
    self.timeCount = 60;
    self.countdownLabel.text = [NSString stringWithFormat:@"%02zd秒后重发", self.timeCount];
    self.countdownLabel.hidden = NO;
    self.resendButton.hidden = YES;
    [self addGetSMSTimer];
}

- (void)stopCountDown {
    [self removeGetSMSTimer];
    self.countdownLabel.hidden = YES;
    self.resendButton.hidden = NO;
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        self.countdownLabel.hidden = YES;
        self.resendButton.hidden = NO;
        return;
    }
    self.countdownLabel.text = [NSString stringWithFormat:@"%02zd秒后重发", self.timeCount];
}

#pragma mark - Timer

- (void)addGetSMSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetSMSTimer {
    [self.timer invalidate];
    self.timer = nil;
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
