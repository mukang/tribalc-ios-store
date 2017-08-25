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
#import "TCHomeMessageSubTitleCell.h"
#import "TCHomeMessageMoneyMiddleCell.h"
#import "TCHomeMessageExtendCreditMiddleCell.h"
#import "TCHomeMessageOnlyMainTitleMiddleCell.h"
#import "TCWalletPasswordViewController.h"
#import "TCGoodsViewController.h"
#import "TCGoodsOrderViewController.h"
#import "TCUserDefaultsKeys.h"

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

@property (weak, nonatomic) TCVerticalImageAndTitleBtn *cardGoodManageBtn;

@property (weak, nonatomic) TCVerticalImageAndTitleBtn *cardOrderManageBtn;

@property (weak, nonatomic) UIView *protocolDownView;

@property (weak, nonatomic) UIView *downLineView;

@property (copy, nonatomic) NSDictionary *unreadNumDic;

@property (weak, nonatomic) UILabel *unreadNumLabel;

@end

@implementation TCStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setUpViews];
    [self loadUnReadPushNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchWallatData) name:TCWalletPasswordDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchWallatData) name:@"TCWalletBankCardDidChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViews:) name:@"TCDidUpdateGoodsManageControl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUnreadMessageNumber:) name:@"TCFetchUnReadMessageNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subtractUnreadNum:) name:@"TCSubtractCurrentUnReadNum" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
    
    [self loadNewDataAndWalletData];
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
    if (!firstMessage) {
        [self loadData];
        return;
    }
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullNewerList count:20 sinceTime:firstMessage.createTime result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (messageWrapper) {
            if ([messageWrapper.content isKindOfClass:[NSArray class]] && messageWrapper.content.count>0) {
                self.tableView.mj_footer.hidden = NO;
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

- (void)loadNewDataAndWalletData {
    [self loadNewData];
    [self fetchWallatData];
}

-(void)firstLoadData {
    [self loadData];
    [self fetchWallatData];
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:0 result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (messageWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.messgaeWrapper = messageWrapper;
            if (!messageWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if ([messageWrapper.content isKindOfClass:[NSArray class]] && messageWrapper.content.count > 0) {
                self.tableView.mj_footer.hidden = NO;
            }else {
                self.tableView.mj_footer.hidden = YES;
            }
            self.messageArr = messageWrapper.content;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)fetchWallatData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        @StrongObj(self)
        if (walletAccount) {
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
            self.messageArr = nil;
            self.tableView.mj_footer.hidden = YES;
            [self loadNewData];
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
            if (self.messageArr.count == 0) {
                self.tableView.mj_footer.hidden = YES;
            }
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
    
    TCHomeMessage *message = self.messageArr[indexPath.row];
    TCMessageType type = message.messageBody.homeMessageType.type;
    TCHomeMessageCell *cell;
    if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageMoneyMiddleCell" forIndexPath:indexPath];
    }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageExtendCreditMiddleCell" forIndexPath:indexPath];
    }else if (type == TCMessageTypeRentCheckIn || type == TCMessageTypeAccountRegister) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageOnlyMainTitleMiddleCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageSubTitleCell" forIndexPath:indexPath];
    }
    
    cell.homeMessage = message;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TCHomeMessage *message = self.messageArr[indexPath.row];
    TCMessageType type = message.messageBody.homeMessageType.type;
    CGFloat scale = TCScreenWidth > 375.0 ? 3.0 : 2.0;
    CGFloat baseH = 80+4*(1/scale);
    if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw) {
        return baseH+102;
    }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment) {
        return baseH+102;
    }else if (type == TCMessageTypeRentCheckIn || type == TCMessageTypeAccountRegister) {
        return baseH+62;
    }else {
        return baseH+143;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateNavigationBar];
    CGRect rect = _headerView.frame;
    if ((NSInteger)scrollView.contentOffset.y <= (NSInteger)-rect.size.height) {
        rect.origin.y = scrollView.contentOffset.y;
        _headerView.frame = rect;
    }else {

    }
}

#pragma mark - Navigation Bar

- (void)updateNavigationBar {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat alpha = (offsetY+TCRealValue(302)) / TCRealValue(199-64);
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *tintColor = nil;
    if (alpha > 0.7) {
        tintColor = TCBlackColor;
    } else {
        tintColor = [UIColor whiteColor];
    }
    [self.navBar setTintColor:tintColor];
    UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:alpha]];
    UIImage *shadowImage = [UIImage imageWithColor:TCARGBColor(221, 221, 221, alpha)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:shadowImage];
}

#pragma mark - Private Methods

- (void)loadUnReadPushNumber {
    @WeakObj(self)
    [[TCBuluoApi api] fetchUnReadPushMessageNumberWithResult:^(NSDictionary *unreadNumDic, NSError *error) {
        @StrongObj(self)
        if ([unreadNumDic isKindOfClass:[NSDictionary class]]) {
            self.unreadNumDic = unreadNumDic;
        }
    }];
}

- (void)subtractUnreadNum:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSNumber *num = dic[@"unreadNum"];
        NSString *type = dic[@"type"];
        if ([num isKindOfClass:[NSNumber class]] && [type isKindOfClass:[NSString class]]) {
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.unreadNumDic];
            NSDictionary *messageTypeCountDic = self.unreadNumDic[@"messageTypeCount"];
            if ([messageTypeCountDic isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *mutableMessageTypeCountDic = [NSMutableDictionary dictionaryWithDictionary:messageTypeCountDic];
                [mutableMessageTypeCountDic setObject:@0 forKey:type];
                mutableDic[@"messageTypeCount"] = mutableMessageTypeCountDic;
                self.unreadNumDic = mutableDic;
            }
        }
    }
}

- (void)setUnreadNumDic:(NSDictionary *)unreadNumDic {
    _unreadNumDic = unreadNumDic;
    [self updateUnReadNumLabel];
}

- (void)setUpUnreadMessageNumber:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        self.unreadNumDic = dic;
    }
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:[[TCBuluoApi api] currentUserSession].storeInfo.name];
    navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : TCBlackColor
                                        };

    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"profile_nav_setting_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    navItem.rightBarButtonItem = settingItem;
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)updateViews:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    NSValue *value = dic[@"isGoodManage"];
    TCStoreInfo *storeInfo = [[TCBuluoApi api] currentUserSession].storeInfo;
    if ([storeInfo.accountType isKindOfClass:[NSString class]]) {
        if ([storeInfo.accountType isEqualToString:@"CARD"]) {
            _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(302), 0, 0, 0);
            _headerView.frame = CGRectMake(0, -TCRealValue(302), self.view.bounds.size.width, TCRealValue(302));
            
            CGFloat width = self.view.bounds.size.width / 3.0;
            if ([value isEqualToValue:@YES]) {
                width = self.view.bounds.size.width / 5.0;
                self.cardOrderManageBtn.hidden = NO;
                self.cardGoodManageBtn.hidden = NO;
            }else {
                self.cardGoodManageBtn.hidden = YES;
                self.cardGoodManageBtn.hidden = NO;
            }
            CGFloat currentX = 0.0;
            for (UIView *view in self.headerView.subviews) {
                if ([view isKindOfClass:[TCVerticalImageAndTitleBtn class]]) {
                    CGRect frame = view.frame;
                    frame.origin.x = currentX;
                    frame.size.width = width;
                    view.frame = frame;
                    currentX += width;
                }
            }
            
        }else if ([storeInfo.accountType isEqualToString:@"PROTOCOL"]) {
            if ([value isEqualToValue:@YES]) {
                _tableView.contentOffset = CGPointMake(0, -(TCRealValue(302-103+88+59+5)));
                _headerView.frame = CGRectMake(0, -TCRealValue(302-103+88+59+5), self.view.bounds.size.width, TCRealValue(302-103+88+59+5));
                _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(302-103+88+59+5), 0, 0, 0);
                self.protocolDownView.hidden = NO;
            }else {
                self.protocolDownView.hidden = YES;
                _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(302), 0, 0, 0);
                _headerView.frame = CGRectMake(0, -TCRealValue(302), self.view.bounds.size.width, TCRealValue(302));
            }
            
            CGRect rect = _downLineView.frame;
            rect.origin.y = _headerView.frame.size.height-rect.size.height;
            _downLineView.frame = rect;
        }
    }
}

- (void)handleClickSettingButton:(UIBarButtonItem *)item {
    TCAppSettingViewController *vc = [[TCAppSettingViewController alloc] init];
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpViews {
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)handleClickGoods {
    TCGoodsViewController *goodVC = [[TCGoodsViewController alloc] init];
    [self.navigationController pushViewController:goodVC animated:YES];
}

- (void)handleClickOrder {
    TCGoodsOrderViewController *orderVC = [[TCGoodsOrderViewController alloc] init];
    if (self.unreadNumDic) {
        orderVC.unReadNumDictionary = self.unreadNumDic;
    }
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)handleClickCol {
    TCCollectViewController *collectVC = [[TCCollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickBill {
    TCWalletBillViewController *billVC = [[TCWalletBillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)handleClickDiscount {
    TCPrivilegeViewController *privilegeVC = [[TCPrivilegeViewController alloc] init];
    [self.navigationController pushViewController:privilegeVC animated:YES];
}

- (void)handleClickCard {
    TCBankCardViewController *bankCardVC = [[TCBankCardViewController alloc] init];
    bankCardVC.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

- (void)handleClickCash {
    if (self.walletAccount) {
        
        if (![self.walletAccount.password isKindOfClass:[NSString class]]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有设置密码，是否要设置密码？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self setPassword];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        if ([self.walletAccount.bankCards isKindOfClass:[NSArray class]] && self.walletAccount.bankCards.count > 0) {
            TCWithdrawViewController *withDrawVC = [[TCWithdrawViewController alloc] initWithWalletAccount:self.walletAccount];
            withDrawVC.completionBlock = ^{
                [self fetchWallatData];
            };
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
        [self fetchWallatData];
    }
}

- (void)setPassword {
    TCWalletPasswordType passwordType = TCWalletPasswordTypeFirstTimeInputPassword;
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:passwordType];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)updateUnReadNumLabel {
    NSDictionary *dic = self.unreadNumDic;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *messageTypeCountDic = dic[@"messageTypeCount"];
        if ([messageTypeCountDic isKindOfClass:[NSDictionary class]]) {
            NSNumber *num = messageTypeCountDic[@"ORDER_SETTLE"];
            if ([num isKindOfClass:[NSNumber class]]) {
                NSInteger number = [num integerValue];
                if (number) {
                    self.unreadNumLabel.hidden = NO;
                    self.unreadNumLabel.text = [NSString stringWithFormat:@"%d", number];
                }else {
                    self.unreadNumLabel.hidden = YES;
                }
            }
        }
    }
}

- (void)createUnReadNumLabelWithTargetView:(UIView *)view {
    UILabel *unreadNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:unreadNumLabel];
    unreadNumLabel.backgroundColor = [UIColor redColor];
    unreadNumLabel.textColor = [UIColor whiteColor];
    unreadNumLabel.font = [UIFont systemFontOfSize:10];
    unreadNumLabel.layer.cornerRadius = 8.0;
    unreadNumLabel.clipsToBounds = YES;
    unreadNumLabel.textAlignment = NSTextAlignmentCenter;
    unreadNumLabel.hidden = YES;
    [unreadNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view).offset(5);
        make.height.equalTo(@16);
        make.width.mas_greaterThanOrEqualTo(@16);
    }];
    
    self.unreadNumLabel = unreadNumLabel;
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
        _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(302), 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        refreshFooter.stateLabel.textColor = TCGrayColor;
        refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
        refreshFooter.automaticallyHidden = YES;
        [refreshFooter setTitle:@"-我是有底线的-" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = refreshFooter;
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataAndWalletData)];
        refreshHeader.stateLabel.textColor = TCBlackColor;
        refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        refreshHeader.lastUpdatedTimeLabel.textColor = TCBlackColor;
        refreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _tableView.mj_header = refreshHeader;
        
        _tableView.mj_footer.hidden = YES;
        [_tableView registerClass:[TCHomeMessageCell class] forCellReuseIdentifier:@"TCHomeMessageCell"];
        [_tableView registerClass:[TCHomeMessageOnlyMainTitleMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageOnlyMainTitleMiddleCell"];
        [_tableView registerClass:[TCHomeMessageSubTitleCell class] forCellReuseIdentifier:@"TCHomeMessageSubTitleCell"];
        [_tableView registerClass:[TCHomeMessageExtendCreditMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageExtendCreditMiddleCell"];
        [_tableView registerClass:[TCHomeMessageMoneyMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageMoneyMiddleCell"];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -TCRealValue(302), self.view.bounds.size.width, TCRealValue(302))];
        [_tableView addSubview: headerView];
        headerView.backgroundColor = [UIColor whiteColor];
        _headerView = headerView;
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TCRealValue(199))];
        [headerView addSubview:topImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(58), ((TCRealValue(135)-TCRealValue(70))/2)+64, TCRealValue(70), TCRealValue(70))];
        iconImageView.layer.cornerRadius = TCRealValue(70)/2;
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImageView.layer.borderWidth = 2.0;
        [topImageView addSubview:iconImageView];
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:storeInfo.ID needTimestamp:YES];
        [iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+TCRealValue(35), TCRealValue(35+64), self.view.frame.size.width-CGRectGetMaxX(iconImageView.frame)-TCRealValue(45)-10, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"会员卡余额";
        [topImageView addSubview:titleLabel];
        
        UILabel *banlanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+TCRealValue(10), titleLabel.frame.size.width, TCRealValue(40))];
        banlanceLabel.textColor = [UIColor whiteColor];
        banlanceLabel.font = [UIFont systemFontOfSize:TCRealValue(39)];
        NSString *str = [NSString stringWithFormat:@"¥%.2f", 0.00];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(0, 1)];
        banlanceLabel.attributedText = attributedStr;
        [topImageView addSubview:banlanceLabel];
        self.balanceLabel = banlanceLabel;
        CGFloat scale = self.view.bounds.size.width > 375.0 ? 3.0 : 2.0;
        NSValue *value = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchGoodManage];
        if ([storeInfo.accountType isKindOfClass:[NSString class]]) {
            if ([storeInfo.accountType isEqualToString:@"CARD"]) {
                topImageView.image = [UIImage imageNamed:@"home_top_col"];
                titleLabel.text = @"会员卡余额";
                CGFloat width = self.view.bounds.size.width / 3;
                if ([value isEqualToValue:@YES]) {
                    width = self.view.bounds.size.width / 5;
                }
                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame)+TCRealValue(10), width, TCRealValue(78)) imageName:@"collection" title:@"收款"];
                [headerView addSubview:colBtn];
                [colBtn addTarget:self action:@selector(handleClickCol) forControlEvents:UIControlEventTouchUpInside];
        
                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"bill" title:@"对账单"];
                [headerView addSubview:billBtn];
                [billBtn addTarget:self action:@selector(handleClickBill) forControlEvents:UIControlEventTouchUpInside];
                
                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"home_discount_manage" title:@"优惠策略"];
                [headerView addSubview:discountBtn];
                [discountBtn addTarget:self action:@selector(handleClickDiscount) forControlEvents:UIControlEventTouchUpInside];
                TCVerticalImageAndTitleBtn *goodsBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(discountBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"home_good_manage" title:@"商品管理"];
                goodsBtn.hidden = YES;
                [headerView addSubview:goodsBtn];
                self.cardGoodManageBtn = goodsBtn;
                [goodsBtn addTarget:self action:@selector(handleClickGoods) forControlEvents:UIControlEventTouchUpInside];
                TCVerticalImageAndTitleBtn *orderBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"home_order_manage" title:@"我的订单"];
                orderBtn.hidden = YES;
                [headerView addSubview:orderBtn];
                self.cardOrderManageBtn = orderBtn;
                
                [self createUnReadNumLabelWithTargetView:orderBtn];
                [self updateUnReadNumLabel];
                
                [orderBtn addTarget:self action:@selector(handleClickOrder) forControlEvents:UIControlEventTouchUpInside];
                if ([value isEqualToValue:@YES]) {
                    goodsBtn.hidden = NO;
                    orderBtn.hidden = NO;
                }
        
            }else if ([storeInfo.accountType isEqualToString:@"PROTOCOL"]) {
                topImageView.image = [UIImage imageNamed:@"home_top_cash"];
                titleLabel.text = @"可提现金额";
                CGFloat width = self.view.bounds.size.width / 5;
                TCVerticalImageAndTitleBtn *colBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame)+TCRealValue(10), width, TCRealValue(78)) imageName:@"collection" title:@"收款"];
                [headerView addSubview:colBtn];
                    [colBtn addTarget:self action:@selector(handleClickCol) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *cashBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(colBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"cash" title:@"提现"];
                [headerView addSubview:cashBtn];
                [cashBtn addTarget:self action:@selector(handleClickCash) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *cardBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cashBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"card" title:@"银行卡"];
                [headerView addSubview:cardBtn];
                [cardBtn addTarget:self action:@selector(handleClickCard) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *billBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cardBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"bill" title:@"对账单"];
                [headerView addSubview:billBtn];
                [billBtn addTarget:self action:@selector(handleClickBill) forControlEvents:UIControlEventTouchUpInside];

                TCVerticalImageAndTitleBtn *discountBtn = [[TCVerticalImageAndTitleBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(billBtn.frame), colBtn.frame.origin.y, width, colBtn.frame.size.height) imageName:@"home_discount_manage" title:@"优惠策略"];
                [headerView addSubview:discountBtn];
                [discountBtn addTarget:self action:@selector(handleClickDiscount) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(discountBtn.frame)+TCRealValue(5), TCScreenWidth, TCRealValue(59))];
                downView.hidden = YES;
                [headerView addSubview:downView];
                self.protocolDownView = downView;
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 1/scale)];
                lineView.backgroundColor = TCSeparatorLineColor;
                [downView addSubview:lineView];
                
                UIButton *goodsManageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [goodsManageBtn setTitle:@"  商品管理" forState:UIControlStateNormal];
                [goodsManageBtn setTitleColor:TCRGBColor(70, 70, 70) forState:UIControlStateNormal];
                [goodsManageBtn setImage:[UIImage imageNamed:@"home_good_manage"] forState:UIControlStateNormal];
                [downView addSubview:goodsManageBtn];
                [goodsManageBtn addTarget:self action:@selector(handleClickGoods) forControlEvents:UIControlEventTouchUpInside];
                goodsManageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                goodsManageBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), TCScreenWidth/2, TCRealValue(58));
                
                UIView *speLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsManageBtn.frame)-(1/scale), 7, 1/scale, TCRealValue(43))];
                speLineView.backgroundColor = TCSeparatorLineColor;
                [goodsManageBtn addSubview:speLineView];
                
                UIButton *orderManageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [orderManageBtn setTitle:@"  订单管理" forState:UIControlStateNormal];
                [orderManageBtn setTitleColor:TCRGBColor(70, 70, 70) forState:UIControlStateNormal];
                [orderManageBtn setImage:[UIImage imageNamed:@"home_order_manage"] forState:UIControlStateNormal];
                [downView addSubview:orderManageBtn];
                [orderManageBtn addTarget:self action:@selector(handleClickOrder) forControlEvents:UIControlEventTouchUpInside];
                orderManageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                orderManageBtn.frame = CGRectMake(CGRectGetMaxX(goodsManageBtn.frame), goodsManageBtn.frame.origin.y, TCScreenWidth/2, goodsManageBtn.frame.size.height);
                
                [self createUnReadNumLabelWithTargetView:orderManageBtn];
                [self updateUnReadNumLabel];
                
                if ([value isEqualToValue:@YES]) {
                    _tableView.contentInset = UIEdgeInsetsMake(TCRealValue(302-103+88+59+5), 0, 0, 0);
                    _headerView.frame = CGRectMake(0, -TCRealValue(302-103+88+59+5), self.view.bounds.size.width, TCRealValue(302-103+88+59+5));
                    _protocolDownView.hidden = NO;
                }
                
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, self.view.bounds.size.width, 1/scale)];
        lineView.backgroundColor = TCSeparatorLineColor;
        [headerView addSubview:lineView];
        self.downLineView = lineView;
        
    }
    return _tableView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    NSLog(@"-- TCStoreViewController dealloc --");
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
