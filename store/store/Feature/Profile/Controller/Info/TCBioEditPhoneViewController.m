//
//  TCBioEditPhoneViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditPhoneViewController.h"

#import "MBProgressHUD+Category.h"

#import "TCBuluoApi.h"

@interface TCBioEditPhoneViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TCBioEditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"联系人手机";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)setupSubviews {
    self.nextButton.layer.cornerRadius = 2.5;
    self.nextButton.layer.masksToBounds = YES;
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

- (IBAction)handleClickNextButton:(UIButton *)sender {
    NSString *phone = self.textField.text;
    if (phone.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入新手机号"];
        return;
    }
    
    TCBioEditSMSViewController *vc = [[TCBioEditSMSViewController alloc] initWithMessageCodeType:TCMessageCodeTypeBindPhone];
    vc.phone = phone;
    vc.editPhoneBlock = self.editPhoneBlock;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)handleTapView:(UITapGestureRecognizer *)sender {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - Other

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
