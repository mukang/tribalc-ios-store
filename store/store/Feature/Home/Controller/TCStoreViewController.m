//
//  TCStoreViewController.m
//  store
//
//  Created by 王帅锋 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreViewController.h"
#import "TCNavigationController.h"
#import "TCCollectViewController.h"
#import "TCSettingViewController.h"
#import "TCStoreInfo.h"
#import "TCBuluoApi.h"
#import "TCVerticalImageAndTitleBtn.h"
#import <UIImage+Category.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import "TCWalletBillViewController.h"
#import "TCBankCardViewController.h"
#import "TCWalletAccount.h"
#import "TCWithdrawViewController.h"
#import "TCAppSettingViewController.h"
#import "TCPrivilegeViewController.h"
#import "TCHomeMessageWrapper.h"
#import "TCHomeMessageCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>
#import "TCHomeCoverView.h"
#import "TCBankCardAddViewController.h"

@interface TCStoreViewController ()<UITableViewDelegate,UITableViewDataSource,TCHomeMessageCellDelegate,TCHomeCoverViewDelegate>

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *messageArr;

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (weak, nonatomic) UILabel *balanceLabel;

@property (weak, nonatomic) UIView *headerView;

@property (strong, nonatomic) TCHomeMessageWrapper *messgaeWrapper;

@property (assign, nonatomic) int64_t sinceTime;

@property (strong, nonatomic) TCHomeCoverView *coverView;

@end

@implementation TCStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setUpViews];
    [self firstLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
}

#pragma mark loadData

- (void)loadNewData {
    @WeakObj(self)
    TCHomeMessage *firstMessage = (TCHomeMessage *)self.messageArr.firstObject;
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullNewerList count:20 sinceTime:firstMessage.createTime result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (messageWrapper) {
            if ([messageWrapper.content isKindOfClass:[NSArray class]] && messageWrapper.content.count>0) {
                NSMutableArray *mutableA = [NSMutableArray arrayWithArray:messageWrapper.content];
                [mutableA addObjectsFromArray:self.messageArr];
                self.messageArr = mutableA;
                NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < messageWrapper.content.count; i++) {
                    [mutableArr addObject: [NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.tableView insertRowsAtIndexPaths:mutableArr withRowAnimation:UITableViewRowAnimationRight];
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}


- (void)loadOldData {
    @WeakObj(self)
    TCHomeMessage *lastMessage = (TCHomeMessage *)self.messageArr.lastObject;
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullOlderList count:20 sinceTime:lastMessage.createTime result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_footer endRefreshing];
        if (messageWrapper) {
            self.messgaeWrapper = messageWrapper;
            if (!messageWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.messageArr];
            [arr addObjectsFromArray:messageWrapper.content];
            self.messageArr = arr;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

-(void)firstLoadData {
    //    [MBProgressHUD showHUD:YES];
    
    //    dispatch_group_t group = dispatch_group_create();
    //    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
    [self loadData];
    //    });
    //    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
    [self fetchWallatData];
    //    });
    
    //    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //        [MBProgressHUD hideHUD:YES];
    //        [self.tableView reloadData];
    //        if (self.walletAccount) {
    //
    //        }
    //    });
}


- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:0 result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        if (messageWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.messgaeWrapper = messageWrapper;
            self.messageArr = messageWrapper.content;
            [self.tableView reloadData];
            if (messageWrapper.hasMore) {
                self.tableView.mj_footer.hidden = NO;
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)fetchWallatData {
    @WeakObj(self)
//    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        @StrongObj(self)
        if (walletAccount) {
//            [MBProgressHUD hideHUD:YES];
            self.walletAccount = walletAccount;
            NSString *str = [NSString stringWithFormat:@"¥%.2f", self.walletAccount.balance];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, 1)];
            self.balanceLabel.attributedText = attributedStr;
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

#pragma mark TCHomeCoverViewDelegate

- (void)didClickNeverShowMessage:(TCHomeMessage *)message {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] ignoreAParticularTypeHomeMessageByMessageType:message.messageBody.homeMessageType.homeMessageTypeEnum result:^(BOOL success, NSError *error) {
       @StrongObj(self)
        if (success) {
            self.coverView.hidden = YES;
            [MBProgressHUD showHUDWithMessage:@"忽略成功" afterDelay:0.5];
            [self loadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)didClickOverLookMessage:(TCHomeMessage *)message currentCell:(TCHomeMessageCell *)cell{
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] ignoreAHomeMessageByMessageID:message.ID result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            self.coverView.hidden = YES;
            [MBProgressHUD hideHUD:YES];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.messageArr];
            [arr removeObject:message];
            self.messageArr = arr;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSArray *indexPathArr = [NSArray arrayWithObjects:indexPath, nil];
            [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"忽略失败，%@", reason]];
        }
    }];
}

#pragma mark TCHomeMessageCellDelegate

- (void)didClickMoreActionBtnWithMessageCell:(UITableViewCell *)cell {
    TCHomeMessageCell *messageCell = (TCHomeMessageCell *)cell;
    CGRect rect = [messageCell convertRect:messageCell.bounds toView:self.navigationController.view];
    NSLog(@"%@", NSStringFromCGRect(rect));
    self.coverView.rect = rect;
    self.coverView.currentCell = (TCHomeMessageCell *)cell;
    self.coverView.homeMessage = messageCell.homeMessage;
    self.coverView.hidden = NO;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCHomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageCell" forIndexPath:indexPath];
    cell.homeMessage = self.messageArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TCHomeMessageCell" configuration:^(TCHomeMessageCell *cell) {
        cell.homeMessage = self.messageArr[indexPath.row];
    }];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rect = _headerView.frame;
    if ((NSInteger)scrollView.contentOffset.y <= (NSInteger)-rect.size.height) {
        rect.origin.y = scrollView.contentOffset.y;
        _headerView.frame = rect;
    }else {

    }
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:[[TCBuluoApi api] currentUserSession].storeInfo.name];

    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile_nav_setting_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    navItem.rightBarButtonItem = settingItem;
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)handleClickSettingButton:(UIBarButtonItem *)item {
    TCAppSettingViewController *vc = [[TCAppSettingViewController alloc] init];
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)col {
    TCCollectViewController *collectVC = [[TCCollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bill {
    TCWalletBillViewController *billVC = [[TCWalletBillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)discount {
    TCPrivilegeViewController *privilegeVC = [[TCPrivilegeViewController alloc] init];
    [self.navigationController pushViewController:privilegeVC animated:YES];
}

- (void)card {
    TCBankCardViewController *bankCardVC = [[TCBankCardViewController alloc] init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

- (void)cash {
    if (self.walletAccount) {
        if ([self.walletAccount.bankCards isKindOfClass:[NSArray class]] && self.walletAccount.bankCards.count > 0) {
            TCWithdrawViewController *withDrawVC = [[TCWithdrawViewController alloc] initWithWalletAccount:self.walletAccount];
            [self.navigationController pushViewController:withDrawVC animated:YES];
        }else {
            //提示绑定银行卡
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有银行卡，是否要添加银行卡？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self addBankCard];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }else {
        
    }
}

- (void)addBankCard {
    TCBankCardAddViewController *vc = [[TCBankCardAddViewController alloc] initWithNibName:@"TCBankCardAddViewController" bundle:[NSBundle mainBundle]];
    vc.walletID = self.walletAccount.ID;
    @WeakObj(self)
    vc.bankCardAddBlock = ^() {
        @StrongObj(self)
        [self fetchWallatData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap {
    self.coverView.hidden = YES;
    self.coverView.homeMessage = nil;
}

- (TCHomeCoverView *)coverView {
    if (_coverView == nil) {
        _coverView = [[TCHomeCoverView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCScreenHeight)];
        _coverView.hidden = YES;
        _coverView.delegate = self;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_coverView addGestureRecognizer:tapG];
        [self.navigationController.view addSubview:_coverView];
    }
    return _coverView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(238), 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        _tableView.mj_footer.hidden = YES;
        [_tableView registerClass:[TCHomeMessageCell class] forCellReuseIdentifier:@"TCHomeMessageCell"];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -TCRealValue(238), self.view.bounds.size.width, TCRealValue(238))];
        [_tableView addSubview: headerView];
        headerView.backgroundColor = [UIColor whiteColor];
        _headerView = headerView;
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TCRealValue(135))];
        [headerView addSubview:topImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(58), (TCRealValue(135)-TCRealValue(70))/2, TCRealValue(70), TCRealValue(70))];
        iconImageView.layer.cornerRadius = TCRealValue(70)/2;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImageView.layer.borderWidth = 2.0;
        [topImageView addSubview:iconImageView];
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:storeInfo.ID needTimestamp:YES];
        [iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+TCRealValue(50), TCRealValue(35), self.view.frame.size.width-CGRectGetMaxX(iconImageView.frame)-TCRealValue(60)-10, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"会员卡余额";
        [topImageView addSubview:titleLabel];
        
        UILabel *banlanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+TCRealValue(10), titleLabel.frame.size.width, TCRealValue(40))];
        banlanceLabel.textColor = [UIColor whiteColor];
        banlanceLabel.font = [UIFont systemFontOfSize:TCRealValue(42)];
        NSString *str = [NSString stringWithFormat:@"¥%.2f", storeInfo.balance];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, 1)];
        banlanceLabel.attributedText = attributedStr;
        [topImageView addSubview:banlanceLabel];
        self.balanceLabel = banlanceLabel;
        
        if ([storeInfo.accountType isKindOfClass:[NSString class]]) {
            if ([storeInfo.accountType isEqualToString:@"CARD"]) {
                topImageView.image = [UIImage imageNamed:@"colBg"];
                CGFloat width = self.view.bounds.size.width / 3;
                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"collection" title:@"收款"];
                [headerView addSubview:colBtn];
        [colBtn addTarget:self action:@selector(col) forControlEvents:UIControlEventTouchUpInside];
        
                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"bill" title:@"对账单"];
                [headerView addSubview:billBtn];
        [billBtn addTarget:self action:@selector(bill) forControlEvents:UIControlEventTouchUpInside];
                
                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"discount" title:@"优惠策略"];
                [headerView addSubview:discountBtn];
        [discountBtn addTarget:self action:@selector(discount) forControlEvents:UIControlEventTouchUpInside];
        
            }else if ([storeInfo.accountType isEqualToString:@"PROTOCOL"]) {
                topImageView.image = [UIImage imageNamed:@"cashBg"];
                CGFloat width = self.view.bounds.size.width / 5;
                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"collection" title:@"收款"];
                [headerView addSubview:colBtn];
                    [colBtn addTarget:self action:@selector(col) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *cashBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"cash" title:@"提现"];
                [headerView addSubview:cashBtn];
        [cashBtn addTarget:self action:@selector(cash) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *cardBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cashBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"card" title:@"银行卡"];
                [headerView addSubview:cardBtn];
        [cardBtn addTarget:self action:@selector(card) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardBtn.frame), CGRectGetMaxY(topImageView.frame), width, TCRealValue(103)) imageName:@"bill" title:@"对账单"];
                [headerView addSubview:billBtn];
        [billBtn addTarget:self action:@selector(bill) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, TCRealValue(103)) imageName:@"discount" title:@"优惠策略"];
                [headerView addSubview:discountBtn];
        [discountBtn addTarget:self action:@selector(discount) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        CGFloat scale = self.view.bounds.size.width > 375.0 ? 3 : 2;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TCRealValue(238)-0.5, self.view.bounds.size.width, 1/scale)];
        lineView.backgroundColor = TCLightGrayColor;
        [headerView addSubview:lineView];
        
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
