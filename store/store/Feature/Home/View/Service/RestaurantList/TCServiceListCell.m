//
//  TCServiceListCell.m
//  store
//
//  Created by 王帅锋 on 17/2/16.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceListCell.h"
#import <Masonry.h>
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>
#import "TCImageURLSynthesizer.h"
#import "TCServices.h"
#import <CoreLocation/CoreLocation.h>
#import "NSObject+Distance.h"

@interface TCServiceListCell ()

@property (strong, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) UILabel *titleL;

@property (strong, nonatomic) UILabel *positionL;

@property (strong, nonatomic) UILabel *perL;

@property (strong, nonatomic) UILabel *tagsL;

@end

@implementation TCServiceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setService:(TCServices *)service {
    if (_service != service) {
        _service = service;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:service.mainPicture];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(175), TCRealValue(130))];
        [self.imageV sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];

        self.titleL.text = service.name;
        
        NSString *positionStr = service.store.markPlace;
        
        if (service.store) {
            
            CGFloat distance = [NSObject distanceWithCoordinateArr:service.store.coordinate];
            
            if (distance) {
                positionStr = [NSString stringWithFormat:@"%@ | %.2fkm", positionStr, distance];
            }
        }
        
        if ([positionStr isKindOfClass:[NSString class]]) {
            NSRange range = [positionStr rangeOfString:@"|"];
            if (range.location != NSNotFound) {
                NSMutableAttributedString *mutableAtt = [[NSMutableAttributedString alloc] initWithString:positionStr];
                [mutableAtt addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
                self.positionL.attributedText = mutableAtt;
            }else {
                self.positionL.text = positionStr;
            }
        }
        
        if (service.personExpense) {
            NSString *str = [NSString stringWithFormat:@"%.0f元/人",service.personExpense];
            NSRange rang = [str rangeOfString:@"元/人"];
            NSMutableAttributedString *mutableAtt = [[NSMutableAttributedString alloc] initWithString:str];
            [mutableAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:rang];
            self.perL.attributedText = mutableAtt;
        }
        
        NSString *style = service.store.category;
        if (_isRes) {
            if ([service.store.cookingStyle isKindOfClass:[NSArray class]]) {
                if (service.store.cookingStyle.count) {
                    style = service.store.cookingStyle.firstObject;
                }
            }
        }
        if ([style isKindOfClass:[NSString class]]) {
            self.tagsL.text = [NSString stringWithFormat:@"  %@  ",style];
        }
    }
}

- (void)setUpUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.positionL];
    [self.contentView addSubview:self.perL];
    [self.contentView addSubview:self.tagsL];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(TCRealValue(15));
        make.width.equalTo(@(TCRealValue(175)));
        make.height.equalTo(@(TCRealValue(130)));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV);
        make.left.equalTo(self.imageV.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-(TCRealValue(10)));
        make.height.lessThanOrEqualTo(@(TCRealValue(40)));
    }];
    
    [self.positionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).offset(5);
    }];
    
    [self.perL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.positionL);
        make.top.equalTo(self.positionL.mas_bottom).offset(5);
    }];
    
    [self.tagsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.perL);
        make.bottom.equalTo(self.imageV);
    }];
}

- (UILabel *)tagsL {
    if (_tagsL == nil) {
        _tagsL = [[UILabel alloc] init];
        _tagsL.font = [UIFont systemFontOfSize:11];
        _tagsL.textColor = TCRGBColor(42, 42, 42);
        _tagsL.layer.cornerRadius = 8.0;
        _tagsL.clipsToBounds = YES;
        _tagsL.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
        _tagsL.layer.borderWidth = 1.0/([UIScreen mainScreen].bounds.size.width <= 375.0 ? 2 : 3);
    }
    return _tagsL;
}

- (UILabel *)perL {
    if (_perL == nil) {
        _perL = [[UILabel alloc] init];
        _perL.font = [UIFont systemFontOfSize:16];
        _perL.textColor = TCRGBColor(252, 108, 38);
    }
    return _perL;
}

- (UILabel *)positionL {
    if (_positionL == nil) {
        _positionL = [[UILabel alloc] init];
        _positionL.font = [UIFont systemFontOfSize:12];
        _positionL.textColor = TCRGBColor(42, 42, 42);
    }
    return _positionL;
}

- (UILabel *)titleL {
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.numberOfLines = 2;
    }
    return _titleL;
}
    
- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.layer.cornerRadius = 3.0;
        _imageV.clipsToBounds = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageV;
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
