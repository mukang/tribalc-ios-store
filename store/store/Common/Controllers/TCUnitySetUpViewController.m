//
//  TCUnitySetUpViewController.m
//  individual
//
//  Created by 王帅锋 on 17/4/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUnitySetUpViewController.h"
#import <TCCommonButton.h>
#import <Masonry.h>
#import <TCDefines.h>

@interface TCUnitySetUpViewController ()<UIActionSheetDelegate>

@property (strong, nonatomic) TCCommonButton *setUrlBtn;

@end

@implementation TCUnitySetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViews];
}

- (void)setUpViews {
    [self.view addSubview:self.setUrlBtn];
    [self.setUrlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(100);
        make.height.equalTo(@40);
    }];
}

- (void)switchBaseUrl {
    UIActionSheet *urlSheet = [[UIActionSheet alloc] initWithTitle:@"切换环境" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"线上环境",@"测试环境", nil];
    
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] objectForKey:TCClientBaseURLKey];
    if ([baseUrl isKindOfClass:[NSString class]]) {
        if ([baseUrl hasPrefix:@"https"]) {
            urlSheet.destructiveButtonIndex = 0;
        }else {
            urlSheet.destructiveButtonIndex = 1;
        }
    }
    
    [urlSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"https://app-services.buluo-gs.com/tribalc/v1.0" forKey:TCClientBaseURLKey];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"http://dev-app-services.buluo-gs.com:10086/tribalc/v1.0" forKey:TCClientBaseURLKey];
            break;
        default:
            break;
    }
}

- (TCCommonButton *)setUrlBtn {
    if (_setUrlBtn == nil) {
        _setUrlBtn = [TCCommonButton buttonWithTitle:@"切换环境" color:TCCommonButtonColorOrange target:self action:@selector(switchBaseUrl)];
    }
    return _setUrlBtn;
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
