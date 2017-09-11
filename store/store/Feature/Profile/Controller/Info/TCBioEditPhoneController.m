//
//  TCBioEditSMSViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditPhoneController.h"
#import "TCBioEditPhoneFailView.h"
#import "TCIDAuthViewController.h"

#import <TCCommonLibs/UIImage+Category.h>

#import "TCBuluoApi.h"

@interface TCBioEditPhoneController () <UITextFieldDelegate,TCBioEditPhoneFailViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *placePhoneNumberTextField;

@property (copy, nonatomic) NSString *code;

@end

@implementation TCBioEditPhoneController {
    __weak TCBioEditPhoneController *weakSelf;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [self.view addGestureRecognizer:tapGesture];
    self.title = @"修改手机号";
    self.view.backgroundColor = TCRGBColor(241, 242, 243);
    self.phoneNumberLabel.text = [TCBuluoApi api].currentUserSession.storeInfo.phone;
    [self setupNavBar];
    [self setupSubviews];
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
    UIImage *normalImage = [UIImage imageWithColor:TCRGBColor(151, 171, 234)];
    UIImage *highlightedImage = [UIImage imageWithColor:TCRGBColor(112, 139, 224)];
    [self.commitButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    self.commitButton.layer.cornerRadius = 2.5;
    self.commitButton.layer.masksToBounds = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCBioEditPhoneFailViewDelegate

- (void)didClickConfirmButton {
    [self deletePersonalBankCards];
}

#pragma mark - Actions

- (void)deletePersonalBankCards {
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] deleteAllPersonalBankCardResult:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [self handleChangeUserPhoneWithCode:self.code];
        }else {
            NSString *reason = error.localizedDescription ?: @"请重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"删除个人全部银行卡失败，%@", reason]];
        }
    }];
}

- (IBAction)handleClickResendButton:(UIButton *)sender {
    
    NSString *newPhone = self.placePhoneNumberTextField.text;
    if ([newPhone isKindOfClass:[NSString class]] && newPhone.length > 0) {
        self.phone = newPhone;
    }else {
        [MBProgressHUD showHUDWithMessage:@"请输入手机号" afterDelay:0.5];
        return;
    }
    
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
    
    NSString *phone = self.placePhoneNumberTextField.text;
    NSString *code = self.textField.text;
    
    if ([phone isKindOfClass:[NSString class]] && phone.length > 0) {
        self.phone = phone;
    }else {
        [MBProgressHUD showHUDWithMessage:@"请输入手机号"];
        return;
    }
    
    if (code.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入验证码"];
        return;
    }
    
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    
    if ([self.placePhoneNumberTextField isFirstResponder]) {
        [self.placePhoneNumberTextField resignFirstResponder];
    }
    
    [self handleChangeUserPhoneWithCode:code];
}

- (void)handleChangeUserPhoneWithCode:(NSString *)code {
    TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
    phoneInfo.phone = self.phone;
    phoneInfo.verificationCode = code;
    self.code = code;
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] changeUserPhone:phoneInfo result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (self.editPhoneBlock) {
                self.editPhoneBlock(YES);
            }
            
            if (error) {
                // 跳到认证页
                TCIDAuthViewController *vc = [[TCIDAuthViewController alloc] initWithNibName:@"TCIDAuthViewController" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            if ([error isKindOfClass:[NSError class]]) {
                NSInteger code = error.code;
                if (code == 409) {
                    [MBProgressHUD hideHUD:YES];
                    TCBioEditPhoneFailView *failView = [[TCBioEditPhoneFailView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCScreenHeight)];
                    failView.delegate = self;
                    [self.navigationController.view addSubview:failView];
                    return;
                }
            }
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"手机号修改失败，%@", reason]];
        }
    }];
}

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
//    TCBiographyViewController *bioVC = self.navigationController.viewControllers[1];
//    [self.navigationController popToViewController:bioVC animated:YES];
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
