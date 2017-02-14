//
//  TCBussinessAuthFailureAndProcessController.m
//  store
//
//  Created by 王帅锋 on 17/2/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBussinessAuthFailureAndProcessController.h"
#import "TCCommonButton.h"
#import <Masonry.h>
#import "TCBusinessLicenceViewController.h"

@interface TCBussinessAuthFailureAndProcessController ()

@property (copy, nonatomic) NSString *status;

@end

@implementation TCBussinessAuthFailureAndProcessController

- (instancetype)initWithAuthStatus:(NSString *)str {
    if (self = [super init]) {
        _status = str;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    NSString *imageName,*labelText,*btnTitle;
    CGFloat topM = 0.0;
    
    if ([_status isEqualToString:@"FAILURE"]) {
        self.title = @"审核失败";
        imageName = @"authFailure";
        labelText = @"审核失败!";
        btnTitle = @"重新提交审核";
        topM = 123.0;
    }else if ([_status isEqualToString:@"PROCESSING"]) {
        imageName = @"authProcess";
        labelText = @"审核中，请耐心等待";
        btnTitle = @"返回上一页";
        topM = 105.0;
        self.title = @"审核中";
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:imageName];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = TCRGBColor(42, 42, 42);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = labelText;
    [self.view addSubview:label];
    
    TCCommonButton *btn = [TCCommonButton buttonWithTitle:btnTitle color:TCCommonButtonColorOrange target:self action:@selector(btnClick)];
    btn.layer.cornerRadius = 3.0;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topM);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(45));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@15);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(label.mas_bottom).offset(TCRealValue(25));
        make.height.equalTo(@40);
    }];
}

- (void)btnClick {
    if ([_status isEqualToString:@"FAILURE"]) {
        TCBusinessLicenceViewController *businessVC = [[TCBusinessLicenceViewController alloc] init];
        businessVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:businessVC animated:YES];
    }else if ([_status isEqualToString:@"PROCESSING"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
