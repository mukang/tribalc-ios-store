//
//  TCGoodsOrderDetailViewController.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderDetailViewController.h"

#import "TCCommonButton.h"
#import "TCGoodsDeliveryView.h"
#import "TCCommonSubtitleViewCell.h"
#import "TCGoodsOrderAddressViewCell.h"
#import "TCGoodsOrderPurchaserViewCell.h"
#import "TCGoodsOrderGoodsViewCell.h"
#import "TCGoodsOrderPriceViewCell.h"
#import "TCGoodsOrderNoteViewCell.h"
#import "TCGoodsOrderStatusViewCell.h"

#import "TCBuluoApi.h"

#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>

@interface TCGoodsOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCommonButton *deliverButton;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *infoArray;

@end

@implementation TCGoodsOrderDetailViewController {
    __weak TCGoodsOrderDetailViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"订单详情";
    
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCCommonSubtitleViewCell class] forCellReuseIdentifier:@"TCCommonSubtitleViewCell"];
    [tableView registerClass:[TCGoodsOrderAddressViewCell class] forCellReuseIdentifier:@"TCGoodsOrderAddressViewCell"];
    [tableView registerClass:[TCGoodsOrderPurchaserViewCell class] forCellReuseIdentifier:@"TCGoodsOrderPurchaserViewCell"];
    [tableView registerClass:[TCGoodsOrderGoodsViewCell class] forCellReuseIdentifier:@"TCGoodsOrderGoodsViewCell"];
    [tableView registerClass:[TCGoodsOrderPriceViewCell class] forCellReuseIdentifier:@"TCGoodsOrderPriceViewCell"];
    [tableView registerClass:[TCGoodsOrderNoteViewCell class] forCellReuseIdentifier:@"TCGoodsOrderNoteViewCell"];
    [tableView registerClass:[TCGoodsOrderStatusViewCell class] forCellReuseIdentifier:@"TCGoodsOrderStatusViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CGFloat bottomMargin = 0;
    if ([self.goodsOrder.status isEqualToString:@"SETTLE"]) {
        TCCommonButton *deliverButton = [TCCommonButton bottomButtonWithTitle:@"发  货"
                                                                        color:TCCommonButtonColorBlue
                                                                       target:self
                                                                       action:@selector(handleClickDeliverButton:)];
        [self.view addSubview:deliverButton];
        self.deliverButton = deliverButton;
        [deliverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
            make.left.bottom.right.equalTo(weakSelf.view);
        }];
        bottomMargin = 49;
    }
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-bottomMargin);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.goodsOrder.itemList.count;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.section) {
        case 0:
        {
            TCGoodsOrderAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderAddressViewCell" forIndexPath:indexPath];
            cell.address = self.goodsOrder.address;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCGoodsOrderPurchaserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderPurchaserViewCell" forIndexPath:indexPath];
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.goodsOrder.picture];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(40, 40)];
            [cell.iconView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
            cell.nameLabel.text = self.goodsOrder.nickName;
            currentCell = cell;
        }
            break;
        case 2:
        {
            TCGoodsOrderGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderGoodsViewCell" forIndexPath:indexPath];
            cell.orderItem = self.goodsOrder.itemList[indexPath.row];
            currentCell = cell;
        }
            break;
        case 3:
        {
            TCGoodsOrderPriceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderPriceViewCell" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"配送方式：";
                cell.subtitleLabel.text = [self.goodsOrder.expressType isEqualToString:@"PAYPOSTAGE"] ? @"全国包邮" : @"不包邮";
            } else if (indexPath.row == 1) {
                cell.titleLabel.text = @"快递运费：";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"¥%0.2f", self.goodsOrder.expressFee];
            } else {
                cell.titleLabel.text = @"价格合计：";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"¥%0.2f", self.goodsOrder.totalFee];
            }
            currentCell = cell;
        }
            break;
        case 4:
        {
            TCGoodsOrderNoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderNoteViewCell" forIndexPath:indexPath];
            cell.noteLabel.text = self.goodsOrder.note ?: @"无";
            currentCell = cell;
        }
            break;
        case 5:
        {
            TCGoodsOrderStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderStatusViewCell" forIndexPath:indexPath];
            cell.infoArray = self.infoArray;
            currentCell = cell;
        }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 107;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 96;
            break;
        case 3:
            return 40;
            break;
        case 4:
            return 56;
            break;
        case 5:
            return 150;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 5) {
        return 4;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Actions

- (void)handleClickDeliverButton:(UIButton *)sender {
    TCGoodsDeliveryView *deliveryView = [[TCGoodsDeliveryView alloc] initWithController:self];
    [deliveryView show];
}

- (NSArray *)handleCreateInfoArrayWithStatus:(NSString *)status {
    NSString *expressNum = [NSString stringWithFormat:@"物流编号：%@", self.goodsOrder.logisticsNum];
    NSString *orderNum = [NSString stringWithFormat:@"订单编号：%@", self.goodsOrder.orderNum];
    NSString *createTime = [NSString stringWithFormat:@"创建时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.createTime / 1000]]];
    NSString *settleTime = [NSString stringWithFormat:@"付款时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.settleTime / 1000]]];
    NSString *deliveryTime = [NSString stringWithFormat:@"发货时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.deliveryTime / 1000]]];
    NSString *receivedTime = [NSString stringWithFormat:@"收货时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.receivedTime / 1000]]];
    
    if ([status isEqualToString:@"NO_SETTLE"]) {
        return @[orderNum, createTime];
    } else if ([status isEqualToString:@"SETTLE"]) {
        return @[orderNum, createTime, settleTime];
    } else if ([status isEqualToString:@"DELIVERY"]) {
        return @[expressNum, orderNum, createTime, settleTime, deliveryTime];
    } else {
        return @[expressNum, orderNum, createTime, settleTime, deliveryTime, receivedTime];
    }
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (NSMutableArray *)infoArray {
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray arrayWithArray:[self handleCreateInfoArrayWithStatus:self.goodsOrder.status]];
    }
    return _infoArray;
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
