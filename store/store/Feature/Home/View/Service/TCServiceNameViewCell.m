//
//  TCServiceNameViewCell.m
//  individual
//
//  Created by 穆康 on 2017/2/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceNameViewCell.h"
#import "TCServiceDetail.h"

@interface TCServiceNameViewCell ()

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *categoryLabel;
@property (weak, nonatomic) UILabel *placeLabel;
@property (weak, nonatomic) UILabel *distanceLabel;
@property (weak, nonatomic) UILabel *perPersonLabel;
@property (weak, nonatomic) UIButton *collectionButton;
@property (weak, nonatomic) UIView *leftLineView;
@property (weak, nonatomic) UIView *rightLineView;
@property (weak, nonatomic) UIView *lineView;

@property (copy, nonatomic) NSDictionary *categoryMap;

@end

@implementation TCServiceNameViewCell

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
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:22.5];
    [self.contentView addSubview:nameLabel];
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.textColor = TCRGBColor(42, 42, 42);
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    categoryLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:categoryLabel];
    
    UILabel *placeLabel = [[UILabel alloc] init];
    placeLabel.textColor = TCRGBColor(42, 42, 42);
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:placeLabel];
    
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.textColor = TCRGBColor(42, 42, 42);
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    distanceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:distanceLabel];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:rightLineView];
    
    UILabel *perPersonLabel = [[UILabel alloc] init];
    perPersonLabel.textColor = TCRGBColor(154, 154, 154);
    perPersonLabel.textAlignment = NSTextAlignmentRight;
    perPersonLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:perPersonLabel];
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [collectionButton setImage:[UIImage imageNamed:@"service_collection"] forState:UIControlStateNormal];
    collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    collectionButton.userInteractionEnabled = NO;
    [self.contentView addSubview:collectionButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCRGBColor(221, 221, 221);
    [self.contentView addSubview:lineView];
    
    self.nameLabel = nameLabel;
    self.categoryLabel = categoryLabel;
    self.placeLabel = placeLabel;
    self.distanceLabel = distanceLabel;
    self.perPersonLabel = perPersonLabel;
    self.collectionButton = collectionButton;
    self.leftLineView = leftLineView;
    self.rightLineView = rightLineView;
    self.lineView = lineView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(42);
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.mas_equalTo(25);
    }];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(30).priorityLow();
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 13.5));
        make.centerX.equalTo(weakSelf.placeLabel.mas_left).offset(-7);
        make.centerY.equalTo(weakSelf.placeLabel);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.5, 13.5));
        make.centerX.equalTo(weakSelf.placeLabel.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.placeLabel);
    }];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.placeLabel);
        make.right.equalTo(weakSelf.leftLineView.mas_centerX).offset(-7);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.placeLabel);
        make.left.equalTo(weakSelf.rightLineView.mas_centerX).offset(7);
    }];
    [self.perPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.placeLabel.mas_bottom).offset(16);
        make.right.equalTo(weakSelf.contentView.mas_centerX).offset(-15);
        make.height.mas_equalTo(13);
    }];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.perPersonLabel);
        make.left.equalTo(weakSelf.contentView.mas_centerX).offset(15);
        make.right.equalTo(weakSelf.contentView).offset(-20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Public Methods

- (void)setServiceDetail:(TCServiceDetail *)serviceDetail {
    _serviceDetail = serviceDetail;
    
    self.nameLabel.text = serviceDetail.name;
    
    self.placeLabel.text = serviceDetail.detailStore.markPlace;
    
    if ([serviceDetail.detailStore.category isEqualToString:@"REPAST"]) {
        if (serviceDetail.detailStore.cookingStyle.count) {
            self.categoryLabel.text = serviceDetail.detailStore.cookingStyle[0];
        }
    } else {
        self.categoryLabel.text = self.categoryMap[serviceDetail.detailStore.category];
    }
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2fkm", serviceDetail.detailStore.distance];
    
    self.perPersonLabel.text = [NSString stringWithFormat:@"%0.0f元/人", serviceDetail.personExpense];
    
    NSString *collectionStr = [NSString stringWithFormat:@"%zd人已收藏", serviceDetail.collectionNum];
    [self.collectionButton setAttributedTitle:[[NSAttributedString alloc] initWithString:collectionStr
                                                                              attributes:@{
                                                                                           NSFontAttributeName: [UIFont systemFontOfSize:11],
                                                                                           NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                                           }]
                                     forState:UIControlStateNormal];
}

#pragma mark - Override Methods

- (NSDictionary *)categoryMap {
    if (_categoryMap == nil) {
        _categoryMap = @{
                         @"REPAST": @"餐饮",
                         @"HAIRDRESSING": @"美容",
                         @"FITNESS": @"健身",
                         @"ENTERTAINMENT": @"休闲娱乐",
                         @"KEEPHEALTHY": @"养生"
                         };
    }
    return _categoryMap;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
