//
//  TCServiceFacilitiesViewController.m
//  store
//
//  Created by 穆康 on 2017/3/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceFacilitiesViewController.h"
#import "TCServiceFacilityView.h"

@interface TCServiceFacilitiesViewController ()

@property (copy, nonatomic) NSDictionary *facilitiesMap;

@end

@implementation TCServiceFacilitiesViewController {
    __weak TCServiceFacilitiesViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"温馨提示";
    
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TCScreenWidth);
        make.top.leading.trailing.bottom.equalTo(scrollView);
    }];
    
    NSInteger rowCout = 4;
    CGFloat topMargin = 30;
    CGFloat leftMargin = 20;
    CGFloat itemWidth = (TCScreenWidth - leftMargin * 2.0) / rowCout;
    CGFloat itemHeight = 36;
    
    TCServiceFacilityView *lastView = nil;
    for (int i=0; i<self.facilities.count; i++) {
        NSInteger row = i / rowCout;
        NSInteger column = i % rowCout;
        NSString *title = self.facilities[i];
        NSString *imageName = self.facilitiesMap[title];
        TCServiceFacilityView *view = [[TCServiceFacilityView alloc] init];
        view.titleLabel.text = title;
        view.imageView.image = [UIImage imageNamed:imageName];
        [containerView addSubview:view];
        
        CGFloat leading = leftMargin + itemWidth * column;
        CGFloat top = topMargin + (itemHeight + topMargin) * row;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
            make.leading.equalTo(containerView).offset(leading);
            make.top.equalTo(containerView).offset(top);
        }];
        lastView = view;
    }
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView).offset(topMargin);
    }];
}

#pragma mark - Override Methods

- (NSDictionary *)facilitiesMap {
    if (_facilitiesMap == nil) {
        _facilitiesMap = @{
                           @"Wi-Fi": @"service_facilities_wi_fi",
                           @"停车位": @"service_facilities_parking",
                           @"地铁": @"service_facilities_subway",
                           @"近商圈": @"service_facilities_business",
                           @"宝宝椅": @"service_facilities_baby_chair",
                           @"有包间": @"service_facilities_room",
                           @"商务宴请": @"service_facilities_business_dinner",
                           @"适合小聚": @"service_facilities_small_party",
                           @"残疾人设施": @"service_facilities_for_disabled",
                           @"有酒吧区域": @"service_facilities_bar",
                           @"周末早午餐": @"service_facilities_weekend_brunch",
                           @"酒店内餐厅": @"service_facilities_restaurants_of_hotel",
                           @"会员权益": @"service_facilities_vip_rights",
                           @"代客泊车": @"service_facilities_valet_parking",
                           @"有观景位": @"service_facilities_scene_seat",
                           @"有机食物": @"service_facilities_organic_food",
                           @"可带宠物": @"service_facilities_pet_ok"
                           };
    }
    return _facilitiesMap;
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
