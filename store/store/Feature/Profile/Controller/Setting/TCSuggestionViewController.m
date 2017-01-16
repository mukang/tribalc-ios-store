//
//  TCSuggestionViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/23.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSuggestionViewController.h"
#import <Masonry.h>
#import <YYText.h>

@interface TCSuggestionViewController () <YYTextViewDelegate>

@property (weak, nonatomic) YYTextView *textView;

@end

@implementation TCSuggestionViewController {
    __weak TCSuggestionViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupContraints];
}

- (void)setupNavBar {
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickSaveButton:)];
}

- (void)setupSubviews {
    YYTextView *textView = [[YYTextView alloc] init];
    textView.backgroundColor = TCRGBColor(242, 242, 242);
    textView.returnKeyType = UIReturnKeyDone;
    textView.layer.cornerRadius = 2.5;
    textView.alwaysBounceVertical = YES;
    textView.alwaysBounceHorizontal = NO;
    textView.textColor = TCRGBColor(42, 42, 42);
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholderText = @"请输入您的想法...";
    textView.placeholderTextColor = TCRGBColor(154, 154, 154);
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupContraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(20);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(220);
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - YYTextViewDelegate

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickSaveButton:(UIBarButtonItem *)sender {
    if (self.textView.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入您的想法"];
        return;
    }
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    [MBProgressHUD showHUDWithMessage:@"感谢您的建议，我们会尽快处理哒"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf handleClickBackButton:nil];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
