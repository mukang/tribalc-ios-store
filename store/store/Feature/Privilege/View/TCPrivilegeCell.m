//
//  TCPrivilegeCell.m
//  store
//
//  Created by 王帅锋 on 2017/7/18.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeCell.h"
#import "TCPrivilege.h"

@interface TCPrivilegeCell ()

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UILabel *privilegeLabel;

@property (strong, nonatomic) UILabel *privilegeTimeLabel;

@property (strong, nonatomic) UILabel *privilegeDateLabel;

@end

@implementation TCPrivilegeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setPrivilege:(TCPrivilege *)privilege {
    if (_privilege != privilege) {
        _privilege = privilege;
        
        NSString *privilegeStr;
        if ([privilege.type isKindOfClass:[NSString class]]) {
            //满减
            if ([privilege.type isEqualToString:@"REDUCE"]) {
                privilegeStr = [NSString stringWithFormat:@"满%.0f元减%.0f元",privilege.condition
,privilege.value];
            } else if ([privilege.type isEqualToString:@"DISCOUNT"]) { //折扣
                privilegeStr = [NSString stringWithFormat:@"满%.0f元%.0f折",privilege.condition
                                ,privilege.value];
            } else if ([privilege.type isEqualToString:@"ALIQUOT"]) { // 满减叠加
                privilegeStr = [NSString stringWithFormat:@"每满%.0f元减%.0f元",privilege.condition
                                ,privilege.value];
            }
            self.privilegeLabel.text = privilegeStr;
        }
        
        if ([privilege.activityTime isKindOfClass:[NSArray class]] && privilege.activityTime.count == 2) {
            
            int64_t startSecond = 0, endSecond = 0, hour = 0, minute = 0;
            startSecond = [[privilege.activityTime firstObject] longLongValue];
            endSecond = [[privilege.activityTime lastObject] longLongValue];
            
            hour = startSecond / 3600;
            minute = (startSecond / 60) % 60;
            NSString *startStr = [NSString stringWithFormat:@"%02lld:%02lld", hour, minute];
            
            hour = endSecond / 3600;
            minute = (endSecond / 60) % 60;
            NSString *endStr = (startSecond < endSecond) ? [NSString stringWithFormat:@"%02lld:%02lld", hour, minute] : [NSString stringWithFormat:@"次日%02lld:%02lld", hour, minute];
            
            self.privilegeTimeLabel.text = [NSString stringWithFormat:@"（有效时间：每天%@-%@）", startStr, endStr];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:privilege.startDate/1000];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:privilege.endDate/1000];
        self.privilegeDateLabel.text = [NSString stringWithFormat:@"有效日期:%@至%@",[dateFormatter stringFromDate:startDate],[dateFormatter stringFromDate:endDate]];
        
    }
}

- (void)setUpViews {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.privilegeLabel];
    [self.bgImageView addSubview:self.privilegeTimeLabel];
    [self.bgImageView addSubview:self.privilegeDateLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(15));
        make.top.equalTo(self.contentView).offset(TCRealValue(8));
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-TCRealValue(15));
    }];
    
    [self.privilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(15);
        make.top.equalTo(self.bgImageView);
        make.height.equalTo(@(TCRealValue(42)));
    }];
    
    [self.privilegeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView).offset(-15);
        make.top.height.equalTo(self.privilegeLabel);
    }];
    
    [self.privilegeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.privilegeLabel);
        make.bottom.equalTo(self.bgImageView);
        make.height.equalTo(@(TCRealValue(19)));
    }];
}

- (UILabel *)privilegeDateLabel {
    if (_privilegeDateLabel == nil) {
        _privilegeDateLabel = [[UILabel alloc] init];
        _privilegeDateLabel.textColor = TCGrayColor;
        _privilegeDateLabel.font = [UIFont systemFontOfSize:9];
    }
    return _privilegeDateLabel;
}

- (UILabel *)privilegeTimeLabel {
    if (_privilegeTimeLabel == nil) {
        _privilegeTimeLabel = [[UILabel alloc] init];
        _privilegeTimeLabel.font = [UIFont systemFontOfSize:10];
        _privilegeTimeLabel.textColor = TCGrayColor;
        _privilegeTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _privilegeTimeLabel;
}

- (UILabel *)privilegeLabel {
    if (_privilegeLabel == nil) {
        _privilegeLabel = [[UILabel alloc] init];
        _privilegeLabel.font = [UIFont systemFontOfSize:16];
        _privilegeLabel.textColor = TCBlackColor;
    }
    return _privilegeLabel;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.image = [UIImage imageNamed:@"privilegeBg"];
    }
    return _bgImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
