//
//  TCBankCardAddViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankCardAddViewController.h"

#import "TCBankPickerView.h"

#import "TCBuluoApi.h"

@interface TCBankCardAddViewController () <UITextFieldDelegate, TCBankPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UIView *bankNameBgView;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@property (weak, nonatomic) IBOutlet UILabel *codeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@property (weak, nonatomic) UIView *pickerBgView;
@property (weak, nonatomic) TCBankPickerView *bankPickerView;

@property (copy, nonatomic) NSString *bankCardID;

@property (strong, nonatomic) TCBankCard *bankCard;

@end

@implementation TCBankCardAddViewController {
    __weak TCBankCardAddViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    self.navigationItem.title = @"银行卡绑定";
    
    [self setupSubviews];
}

- (void)dealloc {
    [self removeGetSMSTimer];
}

- (void)setupSubviews {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: TCGrayColor};
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入开户名称" attributes:attributes];
    self.bankNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择银行" attributes:attributes];
    self.cardNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行卡号" attributes:attributes];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行预留手机号" attributes:attributes];
    self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机验证码" attributes:attributes];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBankNameBgView:)];
    [self.bankNameBgView addGestureRecognizer:tapGesture];
    
    self.cardNumTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.confirmButton.layer.cornerRadius = 2.5;
    self.confirmButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContainerView:)];
    [self.containerView addGestureRecognizer:tap];
}

- (void)reloadUI {
    BOOL isHidden = (self.bankCard.maxPaymentAmount == 0) ? YES : NO;
    self.codeTitleLabel.hidden = isHidden;
    self.codeTextField.hidden = isHidden;
    self.codeButton.hidden = isHidden;
    self.lineView.hidden = isHidden;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCBankPickerViewDelegate

- (void)bankPickerView:(TCBankPickerView *)view didClickConfirmButtonWithBankCard:(TCBankCard *)bankCard {
    self.bankNameTextField.text = bankCard.bankName;
    self.bankCard = bankCard;
    [self dismissPickerView];
    [self reloadUI];
}

- (void)didClickCancelButtonInBankPickerView:(TCBankPickerView *)view {
    [self dismissPickerView];
}

#pragma mark - Actions

- (IBAction)handleClickSendCodeButton:(UIButton *)sender {
    [self prepareAddBankCard];
}

- (IBAction)handleClickConfirmButton:(UIButton *)sender {
    if (self.bankCard.maxPaymentAmount == 0) {
        [self prepareAddBankCard];
    } else {
        [self confirmAddBankCard];
    }
}

- (void)prepareAddBankCard {
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入开户名称"];
        return;
    }
    if (self.bankNameTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请选择银行"];
        return;
    }
    if (self.cardNumTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入银行卡号"];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入银行预留手机号"];
        return;
    }
    
    self.bankCard.userName = self.nameTextField.text;
    self.bankCard.bankCardNum = self.cardNumTextField.text;
    self.bankCard.phone = self.phoneTextField.text;
    self.bankCard.personal = YES;
    self.bankCard.bindType = (self.bankCard.maxPaymentAmount == 0) ? @"WITHDRAW" : @"NORMAL";
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] prepareAddBankCard:self.bankCard walletID:self.walletID result:^(TCBankCard *card, NSError *error) {
        if (card) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bankCard.type == TCBankCardTypeNormal) {
                [weakSelf startCountDown];
                weakSelf.bankCardID = card.ID;
            } else {
                if (weakSelf.bankCardAddBlock) {
                    weakSelf.bankCardAddBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [weakSelf stopCountDown];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"验证码发送失败，%@", reason]];
        }
    }];
}

- (void)confirmAddBankCard {
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入开户名称"];
        return;
    }
    if (self.bankNameTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请选择银行"];
        return;
    }
    if (self.cardNumTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入银行卡号"];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入银行预留手机号"];
        return;
    }
    if (self.bankCardID.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请先获取手机验证码"];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入手机验证码"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] confirmAddBankCardWithID:self.bankCardID verificationCode:self.codeTextField.text walletID:self.walletID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bankCardAddBlock) {
                weakSelf.bankCardAddBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"银行卡绑定失败，%@", reason]];
        }
    }];
}

- (void)handleTapBankNameBgView:(UITapGestureRecognizer *)sender {
    [self.containerView endEditing:YES];
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchReadyToBindBankCardList:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [MBProgressHUD hideHUD:YES];
            [self showPickerViewWithBankCardList:bankCardList];
        } else {
            NSString *message = error.localizedDescription ?: @"获取开户行名称失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)handleTapPickerBgView:(UITapGestureRecognizer *)sender {
    [self dismissPickerView];
}

- (void)handleTapContainerView:(UITapGestureRecognizer *)sender {
    [self.containerView endEditing:YES];
}

#pragma mark - picker view

- (void)showPickerViewWithBankCardList:(NSArray *)bankCardList {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *superView = keyWindow;
    UIView *pickerBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [superView addSubview:pickerBgView];
    self.pickerBgView = pickerBgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPickerBgView:)];
    [pickerBgView addGestureRecognizer:tap];
    
    TCBankPickerView *bankPickerView = [[[NSBundle mainBundle] loadNibNamed:@"TCBankPickerView" owner:nil options:nil] firstObject];
    bankPickerView.banks = bankCardList;
    bankPickerView.delegate = self;
    bankPickerView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, 240);
    [superView addSubview:bankPickerView];
    self.bankPickerView = bankPickerView;
    
    [UIView animateWithDuration:0.25 animations:^{
        pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
        bankPickerView.y = TCScreenHeight - bankPickerView.height;
    }];
}

- (void)dismissPickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.bankPickerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [self.pickerBgView removeFromSuperview];
        [self.bankPickerView removeFromSuperview];
    }];
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
