//
//  TCServicePromptViewCell.m
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServicePromptViewCell.h"
#import "TCServiceFacilityView.h"
#import "TCDetailStore.h"

#define maxCount 4

@interface TCServicePromptViewCell ()

@property (weak, nonatomic) UIButton *titleButton;
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UILabel *businessHoursLabel;
@property (copy, nonatomic) NSDictionary *facilitiesMap;
@property (strong, nonatomic) NSMutableArray *facilityViews;

@end

@implementation TCServicePromptViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setImage:[UIImage imageNamed:@"service_prompt"] forState:UIControlStateNormal];
    [titleButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"温馨提示"
                                                                    attributes:@{
                                                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:22.5],
                                                                                 NSForegroundColorAttributeName: TCRGBColor(42, 42, 42)
                                                                                 }]
                           forState:UIControlStateNormal];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    titleButton.userInteractionEnabled = NO;
    [self.contentView addSubview:titleButton];
    
    UIView *containerView = [[UIView alloc] init];
    [self.contentView addSubview:containerView];
    
    UILabel *businessHoursLabel = [[UILabel alloc] init];
    businessHoursLabel.textColor = TCRGBColor(154, 154, 154);
    businessHoursLabel.textAlignment = NSTextAlignmentCenter;
    businessHoursLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:businessHoursLabel];
    
    self.titleButton = titleButton;
    self.containerView = containerView;
    self.businessHoursLabel = businessHoursLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(22.5);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.mas_equalTo(24.5);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.titleButton.mas_bottom).offset(10);
        make.height.mas_equalTo(36);
    }];
    [self.businessHoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-23);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Public Methods

- (void)setDetailStore:(TCDetailStore *)detailStore {
    _detailStore = detailStore;
    
    if (detailStore.facilities.count) {
        NSInteger showCount = detailStore.facilities.count < maxCount ? detailStore.facilities.count : maxCount;
        if (showCount != self.facilityViews.count) {
            for (UIView *view in self.facilityViews) {
                [view removeFromSuperview];
            }
            [self.facilityViews removeAllObjects];
            
            TCServiceFacilityView *lastView = nil;
            for (int i=0; i<showCount; i++) {
                NSString *title = detailStore.facilities[i];
                NSString *imageName = self.facilitiesMap[title];
                TCServiceFacilityView *view = [[TCServiceFacilityView alloc] init];
                view.titleLabel.text = title;
                view.imageView.image = [UIImage imageNamed:imageName];
                [self.containerView addSubview:view];
                [self.facilityViews addObject:view];
                __weak typeof(self) weakSelf = self;
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(weakSelf.containerView);
                    make.width.mas_equalTo(70);
                    if (lastView) {
                        make.left.equalTo(lastView.mas_right);
                    } else {
                        make.left.equalTo(weakSelf.containerView);
                    }
                }];
                lastView = view;
            }
            [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lastView.mas_right);
            }];
        } else {
            for (int i=0; i<showCount; i++) {
                NSString *title = detailStore.facilities[i];
                NSString *imageName = self.facilitiesMap[title];
                TCServiceFacilityView *view = self.facilityViews[i];
                view.titleLabel.text = title;
                view.imageView.image = [UIImage imageNamed:imageName];
            }
        }
    }
    
    self.businessHoursLabel.text = [NSString stringWithFormat:@"每天 %@", detailStore.businessHours];
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

- (NSMutableArray *)facilityViews {
    if (_facilityViews == nil) {
        _facilityViews = [NSMutableArray arrayWithCapacity:4];
    }
    return _facilityViews;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
