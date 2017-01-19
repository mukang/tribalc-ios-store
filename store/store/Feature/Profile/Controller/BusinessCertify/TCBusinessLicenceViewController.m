//
//  TCBusinessLicenceViewController.m
//  store
//
//  Created by 王帅锋 on 17/1/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBusinessLicenceViewController.h"
#import <Masonry.h>

@interface TCBusinessLicenceViewController ()

@end

@implementation TCBusinessLicenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营业执照认证";
    
    UIView *point1 = [[UIView alloc] init];
    point1.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point1];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"必须公司营业执照，授权委托书，且内容清晰可辨，必填";
    [self.view addSubview:label1];
    label1.textColor = TCRGBColor(154, 154, 154);
    label1.font = [UIFont systemFontOfSize:13];
    
    UIView *point2 = [[UIView alloc] init];
    point2.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point2];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"请您确认拍照权限已开";
    [self.view addSubview:label2];
    label2.textColor = TCRGBColor(154, 154, 154);
    label2.font = [UIFont systemFontOfSize:13];
    
    UIView *point3 = [[UIView alloc] init];
    point3.backgroundColor = TCRGBColor(235, 24, 19);
    [self.view addSubview:point3];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"本页为必填项";
    [self.view addSubview:label3];
    label3.textColor = TCRGBColor(154, 154, 154);
    label3.font = [UIFont systemFontOfSize:13];
    
    
    
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
